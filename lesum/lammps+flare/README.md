# How to run LAMMPS patched with FLARE

After compiling the code (see next section), you can simply use one of the `submit` scripts provided. 

**What to modify in the script?**

Before using one of the submission scripts, make sure to:
- adapt `LAMMPS_PATH` (to `/path/to/bin` where `lmp` recides)
- adapt and/or uncomment one of the suggested execution commands

# How to compile LAMMPS patched with FARE

You need in general the following:

- LAMMPS source code: `git clone -b <release_name> --depth 1 https://github.com/lammps/lammps.git`
- mir-flare source code: `git clone -b <release_name> --depth 1 https://github.com/mir-group/flare.git`

Then, before using one of the provided scripts, patch LAMMPS with the flare, as explained [here](https://mir-group.github.io/flare/installation/lammps.html), which simply is:

```console
$ cd path/to/flare/lammps_plugins
$ ./install.sh /path/to/lammps
```

A final small trick to run flare from LAMMPS (via the `LMPOTF` class):

```console
wget https://gist.githubusercontent.com/anjohan/854b7100e5d2040fb0a5db031789c95f/raw/d466a526e952e9c3aab27e2ae5fe1751696faa2c/lmpotf_lib.patch
cd /path/to/lammps/src && git apply /path.to/lmpotf_lib.patch

```

**What to modify in the scripts?**

Before executing one of the scripts, make sure to:
- adapt the `INSTALL_DIR`, which is the environment variable controlling where the `bin/lmp` is placed. If you set `export INSTALL_DIR=../`, then you'll find `lmp` in `/path/to/lammps/bin`
- adapt MKL_INCLUDE_DIR (usually not necessary, if module paths do not change)

## CPU version

After having followed the instructions below, use and adapt `script_cpu.sh`.

## Known issues

- The FLARE pair style needs the Eigen package. Two workarounds:
    * Clone the eigen repository, and mv eigen/Eigen /path/to/lammps/src/ if it is not easily available on your system.
    * If you are using LAMMPS version > 17Feb22, then you can set `-DPKG_MACHDYN=yes -DDOWNLOAD_EIGEN3=yes` for cmake, and Eigen3 will be downloaded and compiled automatically.
- In order to run large systems, the atoms will be divided into batches to reduce memory usage. The batch size is controlled by the MAXMEM environment variable (in GB). If necessary, set this to an estimate of how much memory FLARE++ can use (i.e., total GPU memory minus LAMMPS’s memory for neighbor lists etc.). If you are memory-limited, you can set MAXMEM=1 or similar, otherwise leave it to a larger number for more parallelism. The default is 12 GB, which should work for most systems while not affecting performance.
- LAMMPS versions earlier than 20 Jan 2023 have an old Kokkos package which comes with a bug related to GCC v12. One simply needs to change a line in lammps/lib/kokkos/bin/nvcc_wrapper, in particular comment `default_arch="sm_35"` and uncomment the following one (should be `#default_arch="sm_50"`). Then the following script will work. Reference: https://github.com/lammps/lammps/issues/3584