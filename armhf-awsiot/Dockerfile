FROM armhf/alpine

#
# A simple image with the AWS IoT python SDK installed for the Raspberry Pi. Note that since
# the base image is ARM specific this file will not work on x86. It's also not possible(*) to
# use Docker Hub's automatic builds since they run on x86 machines.
#
# See https://github.com/aws/aws-iot-device-sdk-python for detailed information about the
# AWS IoT SDK.
#
# Mark Grimes
# 17/May/2017
# Copyright Rymapt Ltd where applicable
# Released under the MIT licence (see https://opensource.org/licenses/MIT)
#
# (*) Apparently there are some techniques that can make this possible (see
#     https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub), but
#     as far as I can see this bakes QEMU into the image. I don't mind the performance hit
#     during the build, but (I may be wrong) even the running container routes everything
#     through QEMU. I don't know what the performance hit of using QEMU when the native
#     architecture matches is, but I don't see the point of taking that hit.
#

RUN apk update && apk add python2

#
# installing pip adds another 10Mb or so onto the image size, so I'll download the zip archive
# and install from there instead
#
RUN mkdir tempBuild \
    && cd tempBuild \
    && wget s3.amazonaws.com/aws-iot-device-sdk-python/aws-iot-device-sdk-python-latest.zip \
    && unzip aws-iot-device-sdk-python-latest.zip \
    && python setup.py install \
    && cd .. \
    && rm -rf tempBuild

#
# Might as well also install the AWS root CA certificate. Not sure where to put this, I'll
# just use /etc for now
#
ADD https://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem /etc/AWSRootCA.pem