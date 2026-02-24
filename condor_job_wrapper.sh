#!/bin/sh

# insert /s/std/bin into the PATH
export PATH=/home/florianoswald/.juliaup/bin/julia:$PATH

exec "$@"