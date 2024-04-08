# ============================================================== #
# INTEL ONEAPI 2023.1.0
# ============================================================== #
#!/bin/bash

# Uncomment here to also download the source code to compile
# git clone --depth 1 -b 4.2.01 https://github.com/kokkos/kokkos.git
# cd kokkos

module purge

module load intel/oneapi-2023.1.0
module load icc/2023.1.0
module load mkl/2023.1.0 
module load openmpi/4.1.5

rm -r build_cpu
mkdir build_cpu
cd build_cpu

# export CXX_COMPILER=/cluster/intel/oneapi/2023.1.0/compiler/2023.1.0/linux/bin/intel64/icc
# -DCMAKE_CXX_COMPILER=$CXX_COMPILER \

export PATH=$MPI_HOME/bin:$PATH

# -DCMAKE_C_COMPILER=/cluster/mpi/openmpi/4.1.5/intel-classic-2023.1/bin/mpicc \
# -DCMAKE_CXX_COMPILER=/cluster/intel/oneapi/2023.1.0/compiler/2023.1.0/linux/bin/intel64/icc \

cmake ../ \
        -DCMAKE_INSTALL_PREFIX=./ \
        -DKokkos_ENABLE_SERIAL=yes \
        -DKokkos_ARCH_ICX=yes

make -j$(nproc)
make install
