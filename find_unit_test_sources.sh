#!/bin/sh

find ./src -type f -name "*.vala" --exclude "Application.vala"
find ./tests/unit -type f -name "*.vala"
