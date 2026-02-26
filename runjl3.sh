#!/bin/bash
# file name: runjl.sh

echo "this job will run a julia script"

/home/florianoswald/.juliaup/bin/julia --project=. -e 'using Pkg; Pkg.instantiate()'
/home/florianoswald/.juliaup/bin/julia --project=. script3.jl
