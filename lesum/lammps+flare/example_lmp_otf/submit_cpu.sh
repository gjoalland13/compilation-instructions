#!/bin/bash
#SBATCH --job-name=ACTIVE-LAMMPS
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --time=00:10:00
#SBATCH --partition=normal,mpi
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

# -----------------> Modify here <----------------- #
LAMMPS_PATH=/home1/bastonero/builds/lammps/builds/stable_2Aug2023_update3/cpu-intel-flare-plumed_lammps-02082023/
PYTHON_VENV_PATH=/home1/bastonero/builds/flare-lammps/
# ------------------------------------------------- #

# 1. Load necessary modules
module purge
module load quantum-espresso/7.2.0-intel-mkl-impi # do not use the ompi, cause it won't work
module load intel/oneapi-2023.1.0
module load compiler/2023.1.0
module load mkl/2023.1.0
source $PYTHON_VENV_PATH/bin/activate

# 2. Export variable
export PATH=$LAMMPS_PATH/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LAMMPS_PATH/lib64

export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# 3. Run simulation
lmp -in in.lammps