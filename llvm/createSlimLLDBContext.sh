#! /bin/bash

# Script to copy over the python files required to run lldb
# Script to create a build context with the absolute minimum required
# for lldb. This includes copying just the required libs and certain
# python files (found by trial and error).
#
# Work in progress

SOURCE_DIR="/usr/lib/python2.7"
DEST_DIR="./pythonPackages"

REQUIRED_FILES="StringIO.py UserDict.py __future__.py _abcoll.py _sysconfigdata.py plat-x86_64-linux-gnu/_sysconfigdata_nd.py _weakrefset.py abc.py code.py codeop.py copy_reg.py functools.py genericpath.py linecache.py os.py posixpath.py re.py site.py sre_compile.py sre_constants.py sre_parse.py stat.py sysconfig.py traceback.py types.py uuid.py warnings.py"

for file in $REQUIRED_FILES; do
	SUBDIR_NAME=`dirname $file`
	if [ "$SUBDIR_NAME" != "." ]; then
		mkdir -p "$DEST_DIR/$SUBDIR_NAME"
	fi
	cp "$SOURCE_DIR/$file" "$DEST_DIR/$file"
done

cp /lib/terminfo/x/xterm .

DOCKERFILE="FROM busybox

COPY bin /llvm/bin/
COPY lib /llvm/lib/
COPY libraries/lib64 /lib64
COPY pythonPackages /llvm/lib/python2.7
COPY xterm /lib/terminfo/x/

ENV PATH \"/llvm/bin:\$PATH\"
ENV PYTHONHOME \"/llvm\"

ENTRYPOINT [\"lldb\"]"

printf "%s\n" "$DOCKERFILE"

