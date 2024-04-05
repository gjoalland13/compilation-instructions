#!/bin/bash

# Load modules
module purge
module load gcc/12
module load FFTW/3.3.10
module load OpenBLAS/0.3.23
module load openmpi-cuda/4.1.5
module load nvhpc/23.3
module load CUDA/12.1

# ! WARNING !
# The following variables might change path with time.
# In case, just find them via `which nvc` and `which mpif90` after loading the modules.
NVC=/cluster/nvidia/hpc_sdk/23.3/Linux_x86_64/23.3/compilers/bin/nvc
MPIF90=/cluster/mpi/openmpi-cuda/4.1.5/gcc-12.2.0/bin/mpif90

# Git clone the repository with a specific version
git clone -b qe-7.2 --depth 1 https://gitlab.com/QEF/q-e.git q-e
cd q-e && mkdir build && cd build

cmake -DCMAKE_C_COMPILER=${NVC} \
 -DCMAKE_Fortran_COMPILER=${MPIF90} \ 
 -DQE_ENABLE_MPI_GPU_AWARE=ON \
 -DQE_ENABLE_CUDA=ON \
 -DQE_ENABLE_OPENACC=ON \
 -DQE_FFTW_VENDOR=FFTW3 ../

make -j8 pwall ph