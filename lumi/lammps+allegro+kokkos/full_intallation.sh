#!/bin/bash

# (NOT FULLY TESTED) !!!

# ==================================================================================== #
# LAMMPS + OPENMP + LIBTORCH v1.13.0 + ROCM 5.2.3 + MPICH @ GPU 
# ==================================================================================== #
INSTALL_DIR=../install
BUILD=$HOME/builds

# ==================================================================================== #
# Download and patch
# ==================================================================================== #
cd ${BUILD}
# LAMMPS 24.02
echo "---------------------------------------------------------------------"
echo "Downloading LAMMPS"
echo "---------------------------------------------------------------------"
wget "https://download.lammps.org/tars/lammps.tar.gz"
tar -xzf lammps.tar.gz
rm lammps.tar.gz
# pair_nequip multicut branch
echo "---------------------------------------------------------------------"
echo "Downloading pair_allegro"
echo "---------------------------------------------------------------------"
git clone -b multicut --depth 1 https://github.com/mir-group/pair_allegro.git pair_allegro
echo "Patching LAMMPS from pair_allegro"
cd pair_allegro
./patch_lammps.sh ../lammps/
cd ..
# Libtorch 1.13.0, ROCM 1.13.0
echo "---------------------------------------------------------------------"
echo "Downloading and extracting Libtorch"
echo "---------------------------------------------------------------------"
wget 'https://download.pytorch.org/libtorch/rocm5.2/libtorch-cxx11-abi-shared-with-deps-1.13.0%2Brocm5.2.zip'
unzip -q libtorch-cxx11-abi-shared-with-deps-1.13.0+rocm5.2.zip 
rm libtorch-cxx11-abi-shared-with-deps-1.13.0+rocm5.2.zip

echo "---------------------------------------------------------------------"
echo "Accessing LAMMPS folder and start compilation"
echo "---------------------------------------------------------------------"
cd lammps

# ==================================================================================== #
# Compile
#   You can comment the `Download and patch` section and use the following
#   if you already downloaded and patched all the repos
# ==================================================================================== #
module load rocm/5.2.3

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
