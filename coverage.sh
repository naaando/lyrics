#!/bin/bash

meson test -C build

cp /usr/share/vala-0.56/vapi/glib-2.0.vapi build/unit.p

find ./build/unit.p -type f -name "*.c" -exec cp {} build/unit.p \;

gcovr --version

gcovr -r $PWD --txt --jacoco -o $PWD/build/meson-logs/ --gcov-ignore-errors=all

cat $PWD/build/meson-logs/coverage.txt
rm $PWD/build/meson-logs/coverage.txt
