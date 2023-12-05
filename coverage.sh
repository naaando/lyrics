#!/bin/bash

ROOT=$PWD

meson test -C build

cp /usr/share/vala-0.56/vapi/glib-2.0.vapi build/unit.p

find ./build/unit.p -type f -name "*.c" -exec cp {} build/unit.p \;

gcovr --version

gcovr -r $ROOT --txt --jacoco -o $ROOT/build/meson-logs/ --gcov-ignore-errors=all

cat $ROOT/build/meson-logs/coverage.txt
rm $ROOT/build/meson-logs/coverage.txt
