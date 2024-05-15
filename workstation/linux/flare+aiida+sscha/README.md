# How to compile AiiDA + FLARE + SSCHA in a container/fresh computer

The easiest way is to use a MAMBA (a faster version of conda) environment.

These instructions should work out of the box. If you encounter any issue, you can:
1. Visit the official websites (flare: https://mir-group.github.io/flare/installation/install.html)
2. See _Known issues_ at the bottom.
3. Contact me.


## Installation instruction

Create the conda environment:

```console
mamba create -yn sscha-flare -c conda-forge python=3.9 numpy git \
spglib=2.2 scipy pytest julia gfortran libblas lapack pip gcc gxx \
cmake openmp liblapacke openblas aiida-core aiida-core.services
mamba activate sscha-flare
```


Clone the following packages under development:
```console
git clone -b development --depth 1 https://github.com/mir-group/flare.git
git clone -b new/flare-interface --depth 1 https://github.com/bastonero/python-sscha.git
git clone --depth 1 https://github.com/SSCHAcode/CellConstructor.git
```

One should also consider properly install AiiDA and making an AiiDA profile afterwards, and set computer and codes.

Install aiida-quantumespresso and some other packages via pip:
```console
pip install ase==3.22 julia aiida-quantumespresso aiida-pseudo
```

Install flare:
```console
cd flare
pip install .
```

Install the SSCHA and its dependencies:
```console
cd ../CellConstructor
python setup.py install
cd ../python-sscha
python setup.py install
pip install tdscha
```

Finally, the SSCHA benefits from julia to automatically speedup the calculation. Install the julia dependencies:
```console
python -c 'import julia; julia.install()'
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
  
- Installing a package using `python setup install` is usually deprecated, and one should rather use pip. Nevertheless, we recommend using it here because the installation of CellConstructor and python-sscha can conflict with Julia installation when using pip. If you prefer to install SSCHA using pip anyway, you may encounter an error when building the PyCall and Conda julia dependencies. Usually, installing the other packages manually first and then the remaining two with the standard procedure will solve the problem. Proceed as follows:
    Type `julia`. Inside the julia prompt, type `]`. The prompt should change color and display the julia version ending with `pkg>`.
    Install the packages:
    ```console
    pkg> add SparseArrays, LinearAlgebra, InteractiveUtils, PyCall
    ```
    This will build all the other dependencies and will raise an error for Conda and PyCall that you should ignore.
    Press backspace to return to the standard julia prompt and exit with
    ```console
    julia> exit()
    ```
    Finally, having the other dependencies installed, julia will handle the error of PyCall and Conda. You can install them using:
    ```console
    python -c 'import julia; julia.install()'
    ```
