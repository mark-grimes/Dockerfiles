#! /bin/bash
#
# N.B. The canonical location of this file is at
# https://github.com/mark-grimes/Dockerfiles/blob/master/extractDynamicLibs.sh
# but it has been included in several projects. Check that location for the most
# recent version.
#
# Extracts all the dynamic libraries required by an executable to another directory.
# The intention is that you can then add just that directory and the executable to
# a docker image to get very small images.
#
# All of the libraries are copied to the output directory so the existing system is
# not modified in any way. The directory structure in the output matches that on the
# original system, so that the original executable's rpath doesn't need to be changed.
#
# Usage is :
#     extractDynamicLibs.sh <executable file> [output directory]
# where
#    <executable file> (required)  - the executable file to get all the dynamic
#                                    libraries for.
#    [output directory] (optional) - the directory to put all the dynamic libraries
#                                    in. Defaults to "libraries".
#
# To add the output to a docker container, you should just ADD the directory to the
# root path, i.e. have this command in your Dockerfile:
#    ADD libraries /
#
# Requires ldd, readlink, mkdir, cp, cd, ln, awk, basename, dirname.
#
# For ldd, you can specify a different executable/script from the system default by
# setting the "LDD" environment variable. You can also copy libraries from a different
# root directory by setting the "SYSROOT" environment variable. This is useful if you
# want to use this script in a cross-compilation toolchain, e.g. with the ldd replacement
# https://gist.github.com/jerome-pouiller/c403786c1394f53f44a3b61214489e6f
# I was able to create docker images for other platforms with e.g.
# LDD="xldd --root /opt/poky/2.4.2/sysroots/cortexa8hf-neon-poky-linux-gnueabi" SYSROOT="/opt/poky/2.4.2/sysroots/cortexa8hf-neon-poky-linux-gnueabi/" extractDynamicLibs.sh MyExecutable
#
# @author Mark Grimes
# @date 18/Feb/2016
# @copyright Copyright Mark Grimes 2018, released under the MIT Licence (https://opensource.org/licenses/MIT)
#

LDD="${LDD:-ldd}"
SYSROOT="${SYSROOT:-}"

# Make sure SYSROOT has a slash at the end
if [ -n "$SYSROOT" ]; then
	case "$SYSROOT" in
		*/);; # If slash at the end do nothing
		*) # else add a slash to the end
			SYSROOT="${SYSROOT}/";;
	esac
fi

# Evaluate the command line arguments
unset EXECUTABLE_NAME
while [ $# -ne 0 ]; do
	case "${1}" in
		--ldd)
			LDD=${2}
			shift
			;;
		--output)
			OUTPUT_DIRECTORY="${2}"
			shift
			;;
		--sysroot)
			SYSROOT="${2}"
			shift
			;;
		-*)
			echo "Unrecognised option \"${1}\"" >&2
			exit 1
			;;
		*)
			if [ -n "${EXECUTABLE_NAME}" ]; then
				echo "Executable has already been set, so ignoring argument \"${1}\"" >&2
			else
				EXECUTABLE_NAME=${1}
			fi
			;;
	esac
	shift
done
if [ -z "${OUTPUT_DIRECTORY}" ]; then
	OUTPUT_DIRECTORY="libraries"
	echo "Output location not specified so trying \"$OUTPUT_DIRECTORY\"" >&2
fi

if [ ! -f $EXECUTABLE_NAME ]; then
	echo "The provided executable name \"$EXECUTABLE_NAME\" does not exist" >&2
	exit
fi

REQUIRED_LIBS=`${LDD} "$EXECUTABLE_NAME" 2>&1`
if [ $? -ne 0 ]; then
	echo "ldd encountered the error :" >&2
	echo "    "$REQUIRED_LIBS  >&2 # Used "2>&1" so any error message will be in the variable
	echo "when run on \"$EXECUTABLE_NAME\"" >&2
	exit
fi

if [ -e "$OUTPUT_DIRECTORY" ]; then
	if [ ! -d "$OUTPUT_DIRECTORY" ]; then
		echo "The requested output directory \"$OUTPUT_DIRECTORY\" already exists, but is not a directory" >&2
		exit
	fi
else
	mkdir -p "$OUTPUT_DIRECTORY"
	if [ $? -ne 0 ]; then
		echo "Unable to create the directory \"$OUTPUT_DIRECTORY\" for the output" >&2
		exit
	fi
fi



IFS=$'\n'

START_DIR=$PWD
VERBOSITY=1

for ITEM in $REQUIRED_LIBS; do
	ORIGINAL=`echo $ITEM | awk '{print $1}'`
	ACTUAL=`echo $ITEM | awk '{if(NF==4) print "readlink -f "$3}' | sh`

	if [ -n "$ACTUAL" ]; then
		# original is a symlink to the actual file, so first need to copy the file being linked to
		SOURCE="${SYSROOT}$ACTUAL"
		FULL_OUTPUT_DIRECTORY="$OUTPUT_DIRECTORY/`dirname "$ACTUAL"`"
		DESTINATION="$FULL_OUTPUT_DIRECTORY/`basename "$ACTUAL"`"
	else
		# No symlinks involved, just need to copy the file
		SOURCE="${SYSROOT}$ORIGINAL"
		FULL_OUTPUT_DIRECTORY="$OUTPUT_DIRECTORY/`dirname "$ORIGINAL"`"
		DESTINATION="$FULL_OUTPUT_DIRECTORY/`basename "$ORIGINAL"`"
	fi

	if [ ! -d "$FULL_OUTPUT_DIRECTORY" ]; then
		mkdir -p "$FULL_OUTPUT_DIRECTORY"
	fi
	if [ -e "$DESTINATION" ]; then
		if [ $VERBOSITY -gt 1 ]; then echo "$DESTINATION already exists, skipping file copy"; fi
	else
		if [ ! -e "$SOURCE" ]; then
			if [ $VERBOSITY -gt 0 ]; then echo "Unable to copy \"$SOURCE\" to \"$FULL_OUTPUT_DIRECTORY\" because the source does not exist" >&2; fi
		else
			cp "$SOURCE" "$FULL_OUTPUT_DIRECTORY"
		fi
	fi

	# Now need to create the symlink (if required)
	if [ -n "$ACTUAL" ]; then
		ACTUAL_BASENAME=`basename "$ACTUAL"`
		if [ "$ORIGINAL" != "$ACTUAL_BASENAME" ]; then
			cd "$FULL_OUTPUT_DIRECTORY"
			if [ -e "$ORIGINAL" ]; then
				if [ $VERBOSITY -gt 1 ]; then echo "$ORIGINAL already exists, skipping symlink"; fi
			else
				ln -s "$ACTUAL_BASENAME" "$ORIGINAL"
			fi
			cd "$START_DIR"
		fi
	fi
done
