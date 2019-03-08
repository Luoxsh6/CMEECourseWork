#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run"
Rscript $HOME/HPC/code/SimulateHPC.R
mv my_test_file* $HOME/HPC/results
echo "R has finished running"
# this is a comment at the end of the file