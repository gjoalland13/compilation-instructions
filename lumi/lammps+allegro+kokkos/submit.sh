#!/bin/bash
#SBATCH --job-name=lammps
#SBATCH --time=0-04:00:00
#SBATCH --mem-per-cpu=8000
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --account={your_project}
#SBATCH --gpus=1
#SBATCH --partition=small-g

# Load modules
module load LUMI/23.09
module load LAMMPS/stable-12Aug2023-update2-pair-allegro-rocm-5.2.3-pytorch-1.13-20240303

# Setup cpu-binding
# This part is only relevant when running with multiple GPUS. Make sure to ask for nodes, not just many gpus
CPU_BIND="map_cpu:49,57,17,25,1,9,33,41"

# Run a program
srun lmp -in myrun.inp > stdout.out 2> stderr.out

nequip-train inputs.yaml

nequip-deploy build --train-dir ./results/training model.pth

traindir=./results/training
nequip-evaluate --train-dir $traindir --dataset-config config.yaml --batch-size 400 --repeat 3 