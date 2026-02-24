#!/bin/bash
# file name: runjl.sh

source ~/.bashrc

echo "this job will run make julia print hi"

julia -e "println(\"hi from the julia command line\")"