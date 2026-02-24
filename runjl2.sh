#!/bin/bash
# file name: runjl.sh

source ~/.bashrc

echo "this job will run a julia script"

/home/florianoswald/.juliaup/bin/julia $(SUBMIT_DIR)/script.jl
