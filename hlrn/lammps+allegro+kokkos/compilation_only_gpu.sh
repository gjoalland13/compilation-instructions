#!/bin/bash

# ==================================================================================== #
# LAMMPS + OPENMP + LIBTORCH v2.2.2 + CUDA 12.0 + NVHPC 23.3 + MKL @ GPU
# ==================================================================================== #
module load cmake/3.26.4
module load nvhpc/23.3
module load fftw3/gcc.8

INSTALL_DIR=../install
BUILD=$HOME/builds

export LIBTORCH_PATH=$BUILD/libtorch/
export CUDNN_PATH=$BUILD/cudnn
export TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0" # trick for libtorch ~v2.2
export MKLROOT=/sw/compiler/intel/compilers_and_libraries_2018.5.274/linux/mkl
export MKL_INCLUDE_DIR=$MKLROOT/include

rm -r build_gpu; mkdir build_gpu; cd build_gpu

cmake ../cmake \
    -D CMAKE_C_COMPILER=nvc \
    -D CMAKE_CXX_COMPILER=nvc++ \
    -D CMAKE_FORTRAN_COMPILER=nvfortran \
    -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
    -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
    -D BUILD_MPI=yes \
    -D BUILD_OMP=yes \
    -D BUILD_SHARED_LIBS=yes \
    -D BUILD_TOOLS=yes \
    -D FFTW3_INCLUDE_DIR=/sw/numerics/fftw3/gcc.8.3.0/3.3.8/skl/include \
    -D FFTW3_LIBRARY=/sw/numerics/fftw3/gcc.8.3.0/3.3.8/skl/lib/libfftw3.so \
    -D FFT=FFTW3 \
    -D CAFFE2_USE_CUDNN=1 \
    -D CUDNN_INCLUDE_DIR=$CUDNN_PATH/include \
    -D CUDNN_LIBRARY_PATH=$CUDNN_PATH/lib/libcudnn.so \
    -D PKG_KOKKOS=yes \
    -D FFT_KOKKOS=CUFFT \
    -D Kokkos_ENABLE_CUDA=yes \
    -D Kokkos_ARCH_AMPERE80=yes \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 24
make install