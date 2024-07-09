#!/bin/bash

# ==================================================================== #
# LAMMPS + INTEL-ONEAPI + MKL + PLUMED @ CPU
# ==================================================================== #

# ------------------------> Modify here ! <------------------------ #
PYTHON_VENV_PATH=${HOME}/builds/flare-lammps
INSTALL_DIR=${HOME}/builds/lammps/builds/stable_2Aug2023_update3/cpu-intel-flare-plumed_lammps-02082023
BUILD=${HOME}/builds
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
    -D PKG_PLUMED=yes \
    -D BUILD_SHARED_LIBS=yes \
    -D DOWNLOAD_PLUMED=yes \
    -D PLUMED_MODE=runtime \
    -D DOWNLOAD_EIGEN3=yes \
    -D PKG_MACHDYN=yes \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 40
make install-python
make install

ase_file="$(dirname $(python3 -c 'import ase; print(ase.__file__)'))/calculators/lammpsrun.py"
sed -i 's/line.startswith(_custom_thermo_mark)/line.strip\(\).startswith\("Step"\)/g' $ase_file