# How to compile FLARE on the HLRN cluster

These instructions should work out of the box. If you encounter any issue, you can:
1. Visit the official website: https://mir-group.github.io/flare/installation/install.html
2. Contact me.

First, load the anaconda module along with git (safer to have the latest one):

```console
module load git
module load anaconda3/2020.11 
```

Then, create a new clean environment:

```console
conda create --name flare python=3.9 pip
```

If you don't want conda to install the environment into your home, then specify a position using the `--prefix` command, e.g. in your scratch:

```console
conda create python=3.9 pip --prefix /scratch/usr/{username}/path/flare
```

Now, load the modules for the C, MKL and CMake compilers:

```console
module load intel/18.0.5
module load impi/2018.4
module load gcc/9.3.0
module load cmake/3.16.2
```

Now choose a folder of choice, and download the source code of FLARE using git and install it via pip:

```console
git clone -b development --depth 1 https://github.com/mir-group/flare.git
pip install ./flare
```

If you want, you can also copy paste this in a shell script, e.g. `install.sh` (remember to `chmod 755 install.sh`):

```console
#!/bin/bash
module load git
module load anaconda3/2020.11 
source $CONDASH
conda activate /scratch/usr/hbiblore/.conda/envs/flare2

module load intel/18.0.5
module load impi/2018.4
module load gcc/9.3.0
module load cmake/3.16.2

pip install ./flare --no-cache-dir
```

If you encounter an __Intel MKL FATAL ERROR__, then this should solve the issue:
```console
conda env config vars set LD_PRELOAD=${CONDA_PREFIX}/lib/libmkl_core.so:${CONDA_PREFIX}/lib/libmkl_intel_thread.so:${CONDA_PREFIX}/lib/libiomp5.so
```

## Interface FLARE with LAMMPS

The official instructions: https://mir-group.github.io/flare/installation/lammps.html
LAMMPS only instructions via CMAKE: https://docs.lammps.org/Build_cmake.html#

Enter the folder of the packages (i.e. where the `flare` source folder is present). Then, copy paste the following in a script and run it!
NOTE: remember to change the conda environment according to your needs (nothing to do in case you just installed it in the normal way without prefix).

```console
#!/bin/bash
module load git
module load anaconda3/2020.11               
source $CONDASH
conda activate flare

module load intel/18.0.5
module load impi/2018.4
module load gcc/9.3.0
module load cmake/3.16.2

rm -rf lammps
git clone -b stable --depth 1 https://github.com/lammps/lammps.git lammps

cd flare/lammps_plugins
./install.sh ../../lammps
cd ../../lammps
mkdir build; cd build
cmake ../cmake -DPKG_MACHDYN=yes -DDOWNLOAD_EIGEN3=yes -DPKG_MANYBODY=yes -D BUILD_SHARED_LIBS=yes -D PYTHON_EXECUTABLE=`which python`
cmake --build . -j8
```

If you want, you can also install the `PyLammps` python package including this extra command after the build (still within the build folder):
```console
make install-python
```

The `lmp` executable can also be used as a normal LAMMPS binary to execute simmulations, nevertheless it would be better to exploit the GPU implementation for big simulations (see: https://mir-group.github.io/flare/installation/lammps.html#compilation-for-gpu-with-kokkos).

Further instructions on installation and how tos for PyLammps: https://docs.lammps.org/Python_head.html
