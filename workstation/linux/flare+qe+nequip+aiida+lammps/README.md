# How to compile AiiDA + FLARE + Quantum ESPRESSO + NequIP + LAMMPS in a container/fresh computer

The easiest way is to use a MAMBA (a faster version of conda) environment.

These instructions should work out of the box. If you encounter any issue, you can:
1. Visit the official websites (flare: https://mir-group.github.io/flare/installation/install.html)
2. See _Known issues_ at the bottom.
3. Contact me.


## Installation instruction

Let's install first some basics along with AiiDA and its services:

```bash
$ mamba create -yn nice -c conda-forge python=3.9 pip aiida-core aiida-core.services gcc gxx cmake openmp liblapacke openblas
$ mamba activate nice
```

Then start the services (`mylocal_db` should be placed somewhere safe, as it will be the place where the databases are stored):

```bash
(nice) $ initdb -D path/to/mylocal_db
(nice) $ pg_ctl -D path/to/mylocal_db -l logfile start
```

The path to `mylocal_db` should be recorded somewhere. As soon as you switch off the computer, the PostgreSQL and the RabbitMQ services will shut down. If `verdi status` complains, then you just need to restart them:

```bash
$ mamba activate nice
(nice) $ pg_ctl -D mylocal_db start
(nice) $ rabbitmq-server -detached
(nice) $ verdi daemon start
```

See also the [aiida documentation](https://aiida.readthedocs.io/projects/aiida-core/en/latest/intro/install_conda.html#intro-get-started-conda-install).


Now we install FLARE. First downloading it using git, and then installing it via pip:

```bash
(nice) $ git clone -b development --depth 1 https://github.com/mir-group/flare.git
(nice) $ pip install ./flare --no-cache-dir
```

Now that flare is installed without MKL (less pain), we can install Quantum ESPRESSO and Pytorch (needed for NequIP):

```bash
(nice) $ mamba install -yn nice -c conda-forge qe pytorch~=-1.12.1 pytorch-cpu~=1.12.1
```

Finally, install NequIP via pip:

```bash
(nice) $ pip install nequip
```

> TODO: pair compilation of LAMMPS with NequIP.

Let's install also LAMMPS along with pair_nequip:

```bash
(nice) $ git clone -b stable_29Sep2021_update2 --depth 1 https://github.com/lammps/lammps.git
(nice) $ git clone https://github.com/mir-group/pair_nequip.git
(nice) $ cd pair_nequip && ./patch_lammps.sh ../lammps/
(nice) $ cd ../lammps
(nice) $ mkdir build
(nice) $ cd build
(nice) $ cmake ../cmake -DCMAKE_PREFIX_PATH=`python -c 'import torch;print(torch.utils.cmake_prefix_path)'` -DPKG_OPENMP=ON -DMKL_INCLUDE_DIR="$CONDA_PREFIX/include"
(nice) $ make -j$(nproc)
```

If you are using Python or pip instead, you should use:

```
-DMKL_INCLUDE_DIR=`python -c "import sysconfig;from pathlib import Path;print(Path(sysconfig.get_paths()[\"include\"]).parent)"`
```

See also the official [documentation](https://github.com/mir-group/pair_nequip) of pair_nequip.

The Allegro model can also be easily installed once `nequip` is installed. See their [allegro](https://github.com/mir-group/allegro) and [pair_allegro](https://github.com/mir-group/pair_allegro) documentations.

NOTE: the Allegro model can be parallelized using MPI, so it can be parallelized accross nodes, whereas the NequIP model cannot, since it is a message passing architecture. Usually the Allegro model provides comparable results to NequIP, so consider to use it!

### A tentative script

If you want, you can also copy paste this in a shell script, e.g. `install.sh` (remember to `chmod 744 install.sh`):

```console
#!/bin/bash

DB_PATH=/path/to/mylocal_db

mamba create --name nice python=3.9 pip aiida-core aiida-core.services gcc gxx cmake openmp liblapacke openblas
mamba activate nice

initdb -D $DB_PATH
pg_ctl -D $DB_PATH -l logfile start
pg_ctl -D mylocal_db start
rabbitmq-server -detached
verdi daemon start

git clone -b development --depth 1 https://github.com/mir-group/flare.git
pip install ./flare --no-cache-dir

mamba install --name nice qe pytorch pytorch-cpu -c conda-forge
pip install nequip
```


## Known issues

Usually, the known issues are:

- FLARE complains with MKL modules ("__Intel MKL FATAL ERROR__"). This is likely to be a dynamical linking problem. To solve it, usually exporting the LD_PRELOAD solves the problem, as follows:
    
    ```console
    $ export LD_PRELOAD=${CONDA_PREFIX}/lib/libmkl_def.so:${CONDA_PREFIX}/lib/libmkl_avx2.so:${CONDA_PREFIX}/lib/libmkl_core.so:${CONDA_PREFIX}/lib/libmkl_intel_lp64.so:${CONDA_PREFIX}/lib/libmkl_intel_thread.so:${CONDA_PREFIX}/lib/libiomp5.so
    ```

    If this doens't solve the issue, then don't use MKL. If you need MKL, e.g. for QE or NequIP, then a possible solution is to first install the other dependencies for FLARE, install FLARE, and then install MKL in the conda/mamba environment along with the other needed packages.

    Look also this [discussion](https://community.intel.com/t5/Intel-oneAPI-Math-Kernel-Library/mkl-fails-to-load/m-p/1155538). 
    If you compiled with a "custom" intel-MKL, then you should substitue `${CONDA_PREFIX}/lib` with the appropiate path(s) (see the discussion for hints on paths). 

- NequIP CPU only would probably crash if you also install torch-vision and torch-audio. Just don't install them, they are not needed anyways.
