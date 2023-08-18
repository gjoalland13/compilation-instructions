# How to compile FLARE on the HLRN cluster

First, load the anaconda module:

```console
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
git clone -b development --depth 1 development https://github.com/mir-group/flare.git
pip install ./flare
```

If you want, you can also copy paste this in a shell script, e.g. `install.sh` (remember to `chmod 755 install.sh`):

```console
#!/bin/bash
module load anaconda3/2020.11 
source $CONDASH
conda activate /scratch/usr/hbiblore/.conda/envs/flare2

module load intel/18.0.5
module load impi/2018.4
module load gcc/9.3.0
module load cmake/3.16.2

pip install ./flare --no-cache-dir
```

