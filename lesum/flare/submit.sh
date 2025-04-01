#!/bin/bash
#SBATCH --job-name=TEST
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

# Clean the paths
module purge

# Quantum ESPRESSO - GPU
module load gcc/12
module load FFTW/3.3.10
module load OpenBLAS/0.3.23
module load openmpi-cuda/4.1.5
module load nvhpc/23.3
module load CUDA/12.1

# FLARE - MKL
module load intel/oneapi-2023.1.0
module load compiler/2023.1.0
module load mkl/2023.1.0
source $HOME/flare/bin/activate

# NVIDIA OVERSCRIPTION ACCELERATION
nvidia-cuda-mps-control -d

# As many OMP as SLURM tasks per node
export OMP_NUM_THREADS=12

flare-otf inputs.yaml