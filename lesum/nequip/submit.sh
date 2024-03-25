#!/bin/bash
#SBATCH --job-name=NEQUIP
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=72:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH -o slurm-report-2.out
#SBATCH -e slurm-report.err

module load gcc/12 # otherwise it doesn't find CUDA modules
module load CUDA/12.1
module load openmpi-cuda/4.1.5

export OMP_NUM_THREADS=12
export SRUN_CPUS_PER_TASK=12

export PATH=/scratch/macke/software_tests/git/bin/:$PATH
source /home1/bastonero/builds/nequip/bin/activate

nequip-train inputs.yaml
# traindir=./results/training
# nequip-deploy --train-dir $traindir
# nequip-evaluate --train-dir $traindir --dataset-config $traindir/config.yaml --batch-size 100 --repeat 3 