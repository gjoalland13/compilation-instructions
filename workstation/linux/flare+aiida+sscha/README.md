# How to compile AiiDA + FLARE + SSCHA in a container/fresh computer

The easiest way is to use a MAMBA (a faster version of conda) environment.

These instructions should work out of the box. If you encounter any issue, you can:
1. Visit the official websites (flare: https://mir-group.github.io/flare/installation/install.html)
2. See _Known issues_ at the bottom.
3. Contact me.


## Installation instruction

Create the conda environment:

```console
mamba create -yn sscha-flare -c conda-forge \
    python=3.9 gfortran libblas lapack julia \
    pip numpy scipy spglib=2.2 gcc gxx cmake openmp liblapacke openblas \
    aiida-core aiida-core.services
mamba activate sscha-flare
```

Clone the following packages under development:
```console
git clone -b development https://github.com/mir-group/flare.git
git clone -b new/flare-interface --depth 1 https://github.com/bastonero/python-sscha.git
git clone --depth 1 https://github.com/SSCHAcode/CellConstructor.git
```

One should also consider properly install AiiDA and making an AiiDA profile afterwards, and set computer and codes.

Install aiida-quantumespresso and some other packages via pip:

```console
pip install ase julia aiida-quantumespresso aiida-pseudo
```

Install the SSCHA and its dependencies:

```
cd CellConstructor
python setup.py install
cd ../python-sscha
python setup.py install
pip install tdscha
```

Now, type `julia`. Inside the julia prompt, type `]`. The prompt should change color and display the julia version ending with `pkg>`. Proceed as follows:

```console
pkg> add SparseArrays, LinearAlgebra, InteractiveUtils, PyCall
```

This should install the required libraries. Press backspace to return to the standard julia prompt and exit with

```console
julia> exit()
```

Setup the julia dependencies correctly:
```console
python -c 'import julia; julia.install()'
```

Finally install flare:
```
cd ../flare
python setup.py install
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
