# HTCondor Quick Reference

## Workflow Summary

### 1. Build Docker Image (once, or after code changes)
```bash
cd /Users/floswald/git/BusLocations
./docker/build.sh
```

### 2. Submit Jobs
```bash
cd htcondor
./submit.sh
```

This submits 1 job:
- `incumbent` - processes incumbent choice variable

### 3. Monitor
```bash
# Check job queue
condor_q

# Watch specific job
condor_q -better-analyze <job_id>

# Follow logs
tail -f entry/job_*.out
tail -f incumbent/job_*.out
```

### 4. Check Results
After jobs complete (check with `condor_q`), outputs are in:
```bash
ls -lh entry/output/chunks/
ls -lh incumbent/output/chunks/
```

## Common Commands

### Job Management
```bash
# View all your jobs
condor_q

# View specific job details
condor_q -l <job_id>

# View completed jobs
condor_history <username>

# Remove a job
condor_rm <job_id>

# Remove all your jobs
condor_rm <username>
```

### Monitoring
```bash
# Watch queue
watch -n 5 condor_q

# Check resource usage
condor_q -l <job_id> | grep -E "(Memory|Disk|Cpus)"

# View job ClassAd
condor_q -l <job_id>
```

### Debugging
```bash
# View why job is idle
condor_q -better-analyze <job_id>

# Check hold reason (if job is on hold)
condor_q -hold <job_id>

# Release held job
condor_release <job_id>
```

## Directory Structure

After submission and completion:
```
htcondor/
├── README.md                   # This file
├── choice_vars.txt            # Job parameters
├── submit.sub                 # Main submit file
├── submit_recompose.sub       # Recompose submit file
├── submit.sh                  # Submit helper script
├── full-pipeline.Rds          # Input data (copied here by submit.sh)
├── entry/                     # Entry job outputs
│   ├── job_*.out             # Standard output
│   ├── job_*.err             # Standard error
│   ├── job_*.log             # HTCondor log
│   └── output/
│       ├── chunks/           # Generated chunk files
│       └── step_ahead.log    # R execution log
└── incumbent/                 # Incumbent job outputs
    └── (same structure)
```

## File Sizes to Monitor

- **Input**: `full-pipeline.Rds` - check size before submission
- **Output**: Each chunk file in `output/chunks/`
- **Total transfer**: Sum of all chunks transferred back

## Typical Issues

### Job Stays Idle
- **Check**: `condor_q -better-analyze <job_id>`
- **Likely**: Docker image not found or resource requirements too high

### Job Holds
- **Check**: `condor_q -hold <job_id>`
- **Common**: Memory exceeded, disk quota, missing input files

### Job Exits Immediately
- **Check**: `cat entry/job_*.err` and `entry/output/step_ahead.log`
- **Common**: R script error, missing dependencies

## Resource Adjustments

Edit `submit.sub` to change:
```
request_cpus    = 4      # Number of CPU cores
request_memory  = 128GB  # RAM
request_disk    = 100GB  # Disk space
```

## Cleaning Up

```bash
# Remove old outputs
rm -rf entry/ incumbent/

# Remove staged data file
rm full-pipeline.Rds

# Start fresh
./submit.sh
```

## See Also

- [DEPLOYMENT.md](../DEPLOYMENT.md) - Complete deployment guide
- [HTCondor Manual](https://htcondor.readthedocs.io/)
