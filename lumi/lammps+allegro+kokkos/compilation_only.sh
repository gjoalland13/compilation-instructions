#!/bin/bash

# (NOT FULLY TESTED) !!!

# ==================================================================================== #
# LAMMPS + OPENMP + LIBTORCH v1.13.0 + ROCM 5.2.3 + MPICH @ GPU
# ==================================================================================== #
module load rocm/5.2.3

INSTALL_DIR=../install
BUILD=$HOME/builds

export LIBTORCH_PATH=$BUILD/libtorch/
export PYTORCH_ROCM_ARCH=gfx90a

rm -r build_gpu; mkdir build_gpu; cd build_gpu

cmake ../cmake \
    -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
    -D CMAKE_C_COMPILER=hipcc \
    -D CMAKE_CXX_COMPILER=hipcc \
    -D PKG_KOKKOS=ON \
    -D Kokkos_ENABLE_CUDA=OFF \
    -D Kokkos_ENABLE_HIP=yes \
    -D Kokkos_ARCH_AMD_GFX90A=yes \
    -D Kokkos_ENABLE_OPENMP=yes \
    -D BUILD_OMP=yes \
    -D BUILD_MPI=yes \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 10
make install
