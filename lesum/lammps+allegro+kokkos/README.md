# How to run LAMMPS patched with Allegro via Kokkos

After compiling the code (see next section), you can simply use one of the `submit` scripts provided. 

**What to modify in the script?**

Before using one of the submission scripts, make sure to:
- adapt `LAMMPS_PATH` (to `/path/to/bin` where `lmp` recides)
- adapt `LIBTORCH_PATH` and (only for GPU) `CUDNN_PATH`
- adapt and/or uncomment one of the suggested execution commands

# How to compile LAMMPS patched with Allegro via Kokkos

To compile the Allegro model you need in general the following

- LAMMPS source code: `git clone -b release_name --depth 1 https://github.com/lammps/lammps.git`
- pair_allegro source code: `git clone -b release_name --depth 1 https://github.com/mir-group/pair_allegro.git`
- Libtorch: see how to get libtorch in this repository
- cuDNN: if not yet installed on the cluster, and if want to use GPUs (recommended, best performance). See cuDNN on the previous folder.

Then, before using one of the provided scripts, patch LAMMPS with the pair_allegro, as explained [here](https://github.com/mir-group/pair_allegro?tab=readme-ov-file#patch-lammps), which simply is:

```console
$ cd pair_allegro
$ ./patch_lammps.sh /path/to/lammps/
```

Then `cd /path/to/lammps`, copy/paste one on the scripts depending on what you want to build. 

**What to modify in the scripts?**

Before executing one of the scripts, make sure to:
- adapt the `INSTALL_DIR`, which is the environment variable controlling where the `bin/lmp` is placed. If you set `export INSTALL_DIR=../`, then you'll find `lmp` in `/path/to/lammps/bin`.
- adapt `LIBTORCH_PATH` and (only for GPU) `CUDNN_PATH`
- adapt MKL_INCLUDE_DIR (usually not necessary, if module paths do not change)

## CPU version

After having followed the instructions below, use and adapt `script_cpu.sh`.

## GPU version

After having followed the instructions below, use and adapt `script_gpu.sh`.

## Known issues

- LAMMPS versions earlier than 20 Jan 2023 have an old Kokkos package which comes with a bug related to GCC v12. One simply needs to change a line in lammps/lib/kokkos/bin/nvcc_wrapper, in particular comment `default_arch="sm_35"` and uncomment the following one (should be `#default_arch="sm_50"`). Then the following script will work. Reference: https://github.com/lammps/lammps/issues/3584
- There is an issue with Libtorch ~v2.2 and CUDA ARCH selection. Solution is to export TORCH_CUDA_ARCH_LIST (see below). Reference: https://github.com/pytorch/pytorch/issues/113948
- There is a compatibility issue for stable LAMMPS versions above 29 Sep 2021 with pair_allegro. Just use the multicut branch. See: https://github.com/mir-group/pair_allegro/issues/30 
- If you want to use the `pair_allegro/stress` branch (or the latest `multicut` branch), note that:
    * If you compiled the Allegro potential having `nequip<6.0.0`, then you will encounter an problem. To solve it, you can:
        1. Simply change in the LAMMPS input `pair_style allegro` to `pair_style allegro3232` (or allegro6464 or mixture of it). 
        32 and 64 refer how the model handles tensor types, which from `nequip=0.6.0` can also be mixed.
        2. Upgrade `nequip` to the develop branch (it should be v0.6.0). To do it, activate the python environment and run:
        `pip install nequip@git+https://github.com/mir-group/nequip.git`. Then, you simply need to recompile the potential (you don't need to redo the optimization). Follow the steps here: https://github.com/mir-group/nequip/issues/69#issuecomment-1129273665
    * There might be some compatibility issue when using a model that cannot predict stress (virial). In this case, you would need to recompile LAMMPS patched with the `pair_allegro/main` branch.