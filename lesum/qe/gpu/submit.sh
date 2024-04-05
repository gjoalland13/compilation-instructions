#!/bin/bash
#SBATCH --job-name=QE-GPU
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

module purge
module load gcc/12
module load FFTW/3.3.10
module load OpenBLAS/0.3.23
module load openmpi-cuda/4.1.5
module load nvhpc/23.3
module load CUDA/12.1

export OMP_NUM_THREADS=1

# ! IMPORTANT !
# It allows for overrides the GPU cards. 
# To test for your system what's more efficient depending
# on number of kpoints etc.
nvidia-cuda-mps-control -d

QEBIN=/path/to/q-e/build/bin

mpirun ${QEBIN}/pw.x -nk 8 -in pw.in > pw.out