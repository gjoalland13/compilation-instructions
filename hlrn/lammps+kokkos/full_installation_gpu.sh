#!/bin/bash

# ==================================================================================== #
# LAMMPS + KOKKOS + MPI + OPENMP + CUDA 12.0 + NVHPC 23.3
# ==================================================================================== #
module load cmake/3.26.4
module load nvhpc/23.3
module load fftw3/gcc.8
module load python/3.9.16

INSTALL_DIR=../install
BUILD=$HOME/builds

# ==================================================================================== #
# Download and patch
# ==================================================================================== #
cd ${BUILD}

# LAMMPS 24.02.07
echo "---------------------------------------------------------------------"
echo "Downloading LAMMPS"
echo "---------------------------------------------------------------------"
git clone -b patch_7Feb2024 --depth 1 https://github.com/lammps/lammps.git

echo "---------------------------------------------------------------------"
echo "Accessing LAMMPS folder and start compilation"
echo "---------------------------------------------------------------------"
cd lammps

# ==================================================================================== #
# Compile
#   You can comment the `Download and patch` section and use the following
#   if you already downloaded and patched all the repos
# ==================================================================================== #
rm -r build_gpu; mkdir build_gpu; cd build_gpu

cmake ../cmake \
    -D CMAKE_C_COMPILER=nvc \
    -D CMAKE_CXX_COMPILER=nvc++ \
    -D CMAKE_FORTRAN_COMPILER=nvfortran \
    -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
    -D BUILD_MPI=yes \
    -D BUILD_OMP=yes \
    -D BUILD_SHARED_LIBS=yes \
    -D BUILD_TOOLS=yes \
    -D FFTW3_INCLUDE_DIR=/sw/numerics/fftw3/gcc.8.3.0/3.3.8/skl/include \
    -D FFTW3_LIBRARY=/sw/numerics/fftw3/gcc.8.3.0/3.3.8/skl/lib/libfftw3.so \
    -D FFT=FFTW3 \
    -D PKG_KSPACE=yes \
    -D PKG_MOLECULE=yes \
    -D PKG_PYTHON=yes \
    -D PKG_KOKKOS=yes \
    -D FFT_KOKKOS=CUFFT \
    -D Kokkos_ENABLE_CUDA=yes \
    -D Kokkos_ARCH_AMPERE80=yes \
    -D Kokkos_ENABLE_OPENMP=yes \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 24
make install