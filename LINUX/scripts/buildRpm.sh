#!/bin/bash
set -e
PACKAGE=netmap

if [ $# -ne 2 ] ; then
    echo 'Usage:  sh buildRpm <VERSION> <BUILD_NUMBER>'
    exit 0
fi
 
VERSION="$1"
BUILD="$2"

echo "Building netmap version: $VERSION $BUILD"

PWD=`pwd`
CWD=$PWD/$PACKAGE
DISTDIR=$CWD/dist/$PACKAGE
PATH=$PATH:/usr/local/probe/bin

rm -rf ~/rpmbuild
rpmdev-setuptree

KERNEL=`uname -r`
sed -e 's/@KERNEL_VERSION@/'${KERNEL%.x86_64}'/g'  packaging/netmap.spec > ~/rpmbuild/SPECS/netmap.spec

cd ..
tar czf $PACKAGE-$VERSION.$BUILD.tar.gz ./*
mv $PACKAGE-$VERSION.$BUILD.tar.gz ~/rpmbuild/SOURCES
cd ~/rpmbuild
rpmbuild -v -bb --define="version ${VERSION}" --define="buildnumber {$BUILD}" --target=x86_64 ~/rpmbuild/SPECS/$PACKAGE.spec
