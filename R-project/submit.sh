#!/bin/bash
# Submit BusLocations step_ahead jobs to HTCondor

set -e  # Exit on error

echo "============================================"
echo "Submitting BusLocations Jobs to HTCondor"
echo "============================================"

# Check if we're in the htcondor directory
if [ ! -f "submit.sub" ]; then
    echo "Error: Must run from htcondor/ directory"
    exit 1
fi

# Check if full-pipeline.Rds exists
DATA_FILE="${R_DROPBOX}/BusLocation/Data/full-pipeline.Rds"

if [ ! -f "$DATA_FILE" ]; then
    echo "Error: Data file not found at: $DATA_FILE"
    echo "Please ensure R_DROPBOX environment variable is set and data file exists"
    exit 1
fi

echo "Data file: $DATA_FILE"
echo "Size: $(du -h "$DATA_FILE" | cut -f1)"
echo ""

# Copy data file to htcondor directory for transfer
echo "Copying data file for HTCondor transfer..."
cp "$DATA_FILE" full-pipeline.Rds

# Create output directory
mkdir -p incumbent logs

echo "Created job directories:"
echo "  - incumbent/ (for incumbent choice_var)"
echo "  - logs/     (for HTCondor logs)"
echo ""

# Submit the job
echo "Submitting job to HTCondor..."
condor_submit submit.sub

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================"
    echo "Jobs submitted successfully!"
    echo "============================================"
    echo ""
    echo "Monitor jobs with:"
    echo "  condor_q"
    echo ""
    echo "Check logs:"
    echo "  tail -f incumbent/job_*.out"
    echo ""
    echo "After jobs complete, outputs will be in:"
    echo "  incumbent/output/chunks/"
    echo ""
    echo "Then run recompose (optional):"
    echo "  ./submit_recompose.sh"
else
    echo ""
    echo "Submission failed!"
    exit 1
fi
