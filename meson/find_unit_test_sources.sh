#!/bin/sh

find ./src -type f -name "*.vala" ! -name "main.vala" > /tmp/lyrics_build_source.txt
find ./tests/unit -type f -name "*.vala" > /tmp/lyrics_build_test_sources.txt
cat /tmp/lyrics_build_source.txt /tmp/lyrics_build_test_sources.txt
