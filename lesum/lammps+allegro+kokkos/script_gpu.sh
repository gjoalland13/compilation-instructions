#!/bin/bash

# ==================================================================== #
# LAMMPS + OPENMPI + LIBTORCH v1.11.0 + CUDA 12.1 + GCC 12 + MKL @ GPU
# ==================================================================== #

# To make the executable to run:
# export TORCH_PATH=/home1/bastonero/builds/libtorch/1.11.0/cu113/lib
# export LD_PRELOAD=$TORCH_PATH/libtorch.so:$TORCH_PATH/libtorch_cuda.so:$TORCH_PATH/libc10.so:$TORCH_PATH/libtorch_cpu.so:$TORCH_PATH/libtorch_cuda_cpp.so:$TORCH_PATH/libtorch_cuda_cu.so:$LD_PRELOAD
# export LD_PRELOAD="$TORCH_PATH/libtorch.so \
#     $TORCH_PATH/libtorch_cuda.so \
#     $TORCH_PATH/libc10.so \
#     $TORCH_PATH/libtorch_cpu.so \
#     $TORCH_PATH/libtorch_cuda_cpp.so \
#     $TORCH_PATH/libtorch_cuda_cu.so \
#     $LD_PRELOAD \
# "

# Where to install the installation folder, containing bin, include, ...
# The `lmp` executable will be found at $INTALL_DIR/bin/lmp
export INSTALL_DIR=../../../builds/stable_2Aug2023_update3/kokkos-gpu-ompi-cuda-12.1-gcc-12-libtorch-1.11.0
# export INSTALL_DIR=../../builds/stable_2Aug2023_update3/kokkos-gpu-ompi-cuda-12.1-gcc-12-libtorch-2.2.2

# NOTES:
# - LAMMPS versions earlier than 20 Jan 2023 have an old Kokkos package
#   which comes with a bug related to GCC v12. One simply needs to change a line
#   in lammps/lib/kokkos/bin/nvcc_wrapper, in particular comment `default_arch="sm_35"`
#   and uncomment the following one (should be `#default_arch="sm_50"`). Then the 
#   following script will work.
#   Reference: https://github.com/lammps/lammps/issues/3584
# - There is an issue with Libtorch ~v2.2. Solution is to export TORCH_CUDA_ARCH_LIST (see below).
#   Reference: https://github.com/pytorch/pytorch/issues/113948
# - Uncomment the following lines if you also want to download the LAMMPS source code as well.
# git clone -b stable_29Sep2021_update2 --depth 1 https://github.com/lammps/lammps.git
# cd lammps

module purge
module load gcc/12
module load CUDA/12.1
module load openmpi-cuda/4.1.5

rm -r build_gpu
mkdir build_gpu
cd build_gpu

# For CUDA v11 uncomment these lines and uncomment the other related 2 below
export LIBTORCH_PATH=/home1/bastonero/builds/libtorch/1.11.0/cu113
export CUDNN_PATH=/home1/bastonero/builds/cudnn/11
# export LIBTORCH_PATH=/home1/bastonero/builds/libtorch/2.2.2/cu121
# export CUDNN_PATH=/home1/bastonero/builds/cudnn/12

export TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0" # trick for libtorch ~v2.2
export MKL_INCLUDE_DIR=/cluster/intel/oneapi/2023.1.0/mkl/2023.1.0/include

cmake ../cmake \
    -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
    -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_PATH \
    -D CUDNN_INCLUDE_DIR=$CUDNN_PATH/include \
    -D CUDNN_LIBRARY_PATH=$CUDNN_PATH/lib/libcudnn.so \
    -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
    -D PKG_KOKKOS=ON \
    -D Kokkos_ENABLE_CUDA=yes \
    -D Kokkos_ARCH_AMPERE80=yes \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 30
make install

# ----------------------------------------------------- #
# Other flags just for reference
# ----------------------------------------------------- #
# cmake ../cmake \
#     -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
#     -D CMAKE_CXX_COMPILER=$MPI_HOME/bin/mpicc \
#     -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_DIR \
#     -D CUDNN_INCLUDE_DIR=$CUDNN_PATH/include \
#     -D CUDNN_LIBRARY_PATH=$CUDNN_PATH/lib/libcudnn.so \
#     -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
#     -D PKG_KOKKOS=ON \
#     -D Kokkos_ENABLE_CUDA=yes \
#     -D Kokkos_ARCH_AMPERE80=yes \
#     -D Kokkos_ENABLE_OPENMP=yes \
#     -D BUILD_OMP=yes \
#     -D BUILD_MPI=yes \