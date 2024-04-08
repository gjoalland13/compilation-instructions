#!/bin/bash
#!/bin/bash
#SBATCH --job-name=TEST
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=12
#SBATCH --time=00:20:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:4
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

module purge
module load gcc/12
module load CUDA/12.1
module load openmpi-cuda/4.1.5

# NVIDIA OVERSCRIPTION ACCELERATION
nvidia-cuda-mps-control -d

export LAMMPS_BIN=/path/to/lammps/build/bin
export PATH=$LAMMPS_BIN:$PATH

export TORCH_PATH=/home1/bastonero/builds/libtorch/1.11.0/cu113/lib
# export LD_PRELOAD=$TORCH_PATH/libtorch.so:$TORCH_PATH/libtorch_cuda.so:$TORCH_PATH/libc10.so:$TORCH_PATH/libtorch_cpu.so:$TORCH_PATH/libtorch_cuda_cpp.so:$TORCH_PATH/libtorch_cuda_cu.so:$LD_PRELOAD
export LD_PRELOAD="$TORCH_PATH/libtorch.so \
    $TORCH_PATH/libtorch_cuda.so \
    $TORCH_PATH/libc10.so \
    $TORCH_PATH/libtorch_cpu.so \
    $TORCH_PATH/libtorch_cuda_cpp.so \
    $TORCH_PATH/libtorch_cuda_cu.so \
    $LD_PRELOAD \
"

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# For parallelization flags, see: https://docs.lammps.org/Speed_kokkos.html#running-on-gpus

# 1 node, 12 MPI tasks/node, 4 GPUs/node (4 GPUs total)
mpirun -np 4 lmp -k on g 2 t 12 -sf kk -in in.lj