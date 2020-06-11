#!/bin/bash
#SBATCH --job-name=BMp
#SBATCH --output=BMp%j.out
#SBATCH --error=BMp%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jaoto@ucsc.edu
#SBATCH --partition=am-148-s20

module load cuda10.0/10.0

./paru.exe
