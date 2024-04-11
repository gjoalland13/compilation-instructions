# How to get a working LAMMPS patched using Nequip/Allegro, and Nequip/Allegro

This kind following instructions have been provided by Henrique Musseli Cezar (Hylleraas Centre for Quantum Molecular Sciences, University of Oslo, Norway).

'''

1) Download the easyconfig:

wget "https://462000008.lumidata.eu/easyconfigs/LAMMPS-stable-12Aug2023-update2-pair-allegro-rocm-5.2.3-pytorch-1.13-20240303.eb"

2) If not already done, set the environment variable to specify where
easybuild should install softwares. For example:

export EBU_USER_PREFIX=/project/project_465000259/EasyBuild

3) Install the container:

module load LUMI/23.09
module load partition/container
module load EasyBuild-user

eb LAMMPS-stable-12Aug2023-update2-pair-allegro-rocm-5.2.3-pytorch-1.13-20240303.eb

4) Using the container:

Once the container is installed, you can load it:

module purge
module load LUMI/23.09
module load LAMMPS/stable-12Aug2023-update2-pair-allegro-rocm-5.2.3-pytorch-1.13-20240303

Wrapper scripts for the tools installed in the container are created by the
EasyBuild setup sot that you can use the tools as if they were not in a
container. For example, LAMMPS can be invoked using "lmp". The same for
"nequip-benchmark", "nequip-deploy", "nequip-evaluate" and "nequip-train".
'''



## How to compile LAMMPS patched using Nequip/Allegro (NOT FULLY TESTED, MIGHT NOT WORK)

The `full_installation.sh` download and compiles everything in a single-shot. You may need to change the `BUILD` variable,
which indicated where the packages are expected to be built (NOTE: the folder should exist, there's no check).

The `compilation_only.sh` is a clean version of the previous one, with only compilation instructions via CMake 
(NOTE: you are supposed to use it within the lammps directory).

## Known issues

- Apparently there is some problem with LAMMPS and Kokkok in the 2Aug2023 version. Using the 7Feb2024 doesn't give issues. But feel free to try.