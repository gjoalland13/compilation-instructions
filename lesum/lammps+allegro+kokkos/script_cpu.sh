#!/bin/bash

# ==================================================================== #
# LAMMPS + OPENMPI + LIBTORCH v1.11.0 + INTEL-ONEAPI + MKL @ CPU
# ==================================================================== #

export INSTALL_DIR=../../../builds/stable_29Sep2021_update2/kokkos-cpu-ompi-intel_oneapi-2023-libtorch-1.11.0

# To make the executable to run, put the folliwing lines:
# TORCH_PATH=/home1/bastonero/builds/libtorch/1.11.0/cpu/lib/
# export LD_PRELOAD="$TORCH_PATH/libtorch.so \
#         $TORCH_PATH/libtorch_cpu.so \
#         $TORCH_PATH/libc10.so \
#         $LD_PRELOAD \
# "

module purge

module load intel/oneapi-2023.1.0
module load icc/2023.1.0
module load mkl/2023.1.0 
module load openmpi/4.1.5

rm -r build_cpu
mkdir build_cpu
cd build_cpu

export MKL_INCLUDE=$MKLROOT/MKL_INCLUDE
export LIBTORCH_PATH=/home1/bastonero/builds/libtorch/1.11.0/cpu

cmake ../cmake \
        -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
        -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
        -D PKG_KOKKOS=ON \
        -D Kokkos_ENABLE_OPENMP=yes \
        -D Kokkos_ENABLE_SERIAL=yes \
        -D Kokkos_ARCH_ICX=yes \
        -D BUILD_OMP=yes \
        -D BUILD_MPI=yes \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 20
make install