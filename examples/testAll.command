#! /bin/sh
# Run all the tests from the Mac OSX Finder
#
D=`dirname "$0"`
cd $D
make test
exit
