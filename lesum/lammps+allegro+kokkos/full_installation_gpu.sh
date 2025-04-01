#!/bin/bash

# ==================================================================================== #
# LAMMPS + OPENMPI + OPENMP + LIBTORCH v2.2.2 + CUDA 12.1 + GCC 12 + MKL @ GPU
# ==================================================================================== #
module purge
module load gcc/12
module load CUDA/12.1
module load openmpi-cuda/4.1.5
export MKLROOT=/cluster/intel/oneapi/2023.1.0/mkl/2023.1.0/include

INSTALL_DIR=../install
BUILD=$HOME/builds

# ==================================================================================== #
# Download and patch
# ==================================================================================== #
cd ${BUILD}
# LAMMPS 23.08
echo "---------------------------------------------------------------------"
echo "Downloading LAMMPS"
echo "---------------------------------------------------------------------"
git clone -b stable_2Aug2023_update3 --depth 1 https://github.com/lammps/lammps.git lammps
# pair_nequip multicut branch
echo "---------------------------------------------------------------------"
echo "Downloading pair_allegro"
echo "---------------------------------------------------------------------"
git clone -b multicut --depth 1 https://github.com/mir-group/pair_allegro.git pair_allegro
echo "Patching LAMMPS from pair_allegro"
cd pair_allegro
./patch_lammps.sh ../lammps/
cd ..
# Libtorch 2.2.2, cuda 12.1
echo "---------------------------------------------------------------------"
echo "Downloading and extracting Libtorch"
echo "---------------------------------------------------------------------"
wget 'https://download.pytorch.org/libtorch/cu121/libtorch-cxx11-abi-shared-with-deps-2.2.2%2Bcu121.zip'
unzip -q libtorch-cxx11-abi-shared-with-deps-2.2.2+cu121.zip
rm libtorch-cxx11-abi-shared-with-deps-2.2.2+cu121.zip
# cuDNN
echo "---------------------------------------------------------------------"
echo "Downloading and extracting cuDNN"
echo "---------------------------------------------------------------------"
wget "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.0.0.312_cuda12-archive.tar.xz"
tar -xf cudnn-linux-x86_64-9.0.0.312_cuda12-archive.tar.xz
mv cudnn-linux-x86_64-9.0.0.312_cuda12-archive cudnn
rm cudnn-linux-x86_64-9.0.0.312_cuda12-archive.tar.xz

echo "---------------------------------------------------------------------"
echo "Accessing LAMMPS folder and start compilation"
echo "---------------------------------------------------------------------"
cd lammps

# ==================================================================================== #
# Compile
#   You can comment the `Download and patch` section and use the following
#   if you already downloaded and patched all the repos
# ==================================================================================== #
rm -r build_gpu
mkdir build_gpu
cd build_gpu

export LIBTORCH_PATH=$BUILD/libtorch/
export CUDNN_PATH=$BUILD/cudnn
export TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0" # trick for libtorch ~v2.2
export MKL_INCLUDE_DIR=$MKLROOT/include

cmake ../cmake \
    -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
    -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_PATH \
    -D CUDNN_INCLUDE_DIR=$CUDNN_PATH/include \
    -D CUDNN_LIBRARY_PATH=$CUDNN_PATH/lib/libcudnn.so \
    -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
    -D PKG_KOKKOS=ON \
    -D Kokkos_ENABLE_CUDA=yes \
    -D Kokkos_ARCH_AMPERE80=yes \
    -D Kokkos_ENABLE_OPENMP=yes \
    -D BUILD_OMP=yes \
    -D CAFFE2_USE_CUDNN=1 \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 24
make install