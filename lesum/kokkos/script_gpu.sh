# ============================================================== #
# CUDA 12
# ============================================================== #
#!/bin/bash

# Uncomment here to also download the source code
# git clone --depth 1 -b 4.2.01 https://github.com/kokkos/kokkos.git
# cd kokkos

module purge
module load gcc/12
module load FFTW/3.3.10
module load OpenBLAS/0.3.23
module load nvhpc/23.3
module load CUDA/12.1
module load openmpi-cuda/4.1.5

rm -r build
mkdir build
cd build

export CUDA_DIR=/cluster/nvidia/cuda/12.0.1/
# export CXX_COMPILER=/cluster/nvidia/hpc_sdk/23.3/Linux_x86_64/23.3/compilers/bin/nvc++

# -DCMAKE_CXX_COMPILER=$CXX_COMPILER \
cmake ../ \
        -DCMAKE_INSTALL_PREFIX=./ \
        -DKokkos_CUDA_DIR=$CUDA_DIR \
        -DKokkos_ENABLE_CUDA=ON \
        -DKokkos_ENABLE_CUDA_UVM=OFF \
        -DKokkos_ENABLE_OPENMP=ON \
        -DKokkos_ARCH_AMPERE80=ON

make -j 10
make install


# ============================================================== #
# CUDA 11
# ============================================================== #
#!/bin/bash

# Uncomment here to also download the source code to compile
# git clone --depth 1 -b 4.2.01 https://github.com/kokkos/kokkos.git
# cd kokkos

module purge
module load gcc/12
module load FFTW/3.3.10
module load OpenBLAS/0.3.23
module load nvhpc/23.3
module load CUDA/11.8
module load openmpi-cuda/4.1.5

rm -r build
mkdir build
cd build

export CUDA_DIR=/cluster/nvidia/cuda/11.8.0/
export CXX_COMPILER=/cluster/nvidia/hpc_sdk/23.3/Linux_x86_64/23.3/compilers/bin/nvc++

cmake ../ \
        -DCMAKE_INSTALL_PREFIX=./ \
        -DCMAKE_CXX_COMPILER=$CXX_COMPILER \
        -DKokkos_CUDA_DIR=$CUDA_DIR \
        -DKokkos_ENABLE_CUDA=ON \
        -DKokkos_ENABLE_CUDA_UVM=OFF \
        -DKokkos_ENABLE_OPENMP=ON \
        -DKokkos_ARCH_AMPERE80=ON

make -j 10
make install