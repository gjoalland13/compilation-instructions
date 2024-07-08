#!/bin/bash

# ==================================================================== #
# LAMMPS + INTEL-ONEAPI + MKL + PLUMED @ CPU
# ==================================================================== #

# ------------------------> Modify here ! <------------------------ #
export PYTHON_VENV_PATH=/home1/bastonero/builds/flare-lammps
export INSTALL_DIR=../../../builds/stable_29Sep2021_update2/kokkos-cpu-ompi-intel_oneapi-2023-libtorch-1.11.0
# ----------------------------------------------------------------- #

source $PYTHON_VENV_PATH/bin/activate

module purge
module load intel/oneapi-2023.1.0
module load compiler/2023.1.0
module load mkl/2023.1.0

rm -r build_cpu
mkdir build_cpu
cd build_cpu

export MKL_INCLUDE_DIR=/cluster/intel/oneapi/2023.1.0/mkl/2023.1.0/include

cmake ../cmake \
    -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
    -D BUILD_MPI=no \
    -D BUILD_OMP=yes \
    -D PKG_PYTHON=yes \
    -D PKG_MANYBODY=yes \
    -D BUILD_SHARED_LIBS=yes \
    -D DOWNLOAD_PLUMED=yes \
    -D PLUMED_MODE=static \
    -D DOWNLOAD_EIGEN3=yes \
    -D PKG_MACHDYN=yes \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 40
make install-python
make install