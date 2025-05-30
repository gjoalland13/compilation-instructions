# How to compile AiiDA + FLARE + SSCHA in a container/fresh computer

The easiest way is to use a MAMBA (a faster version of conda) environment.

These instructions should work out of the box. If you encounter any issue, you can:
1. Visit the official websites (flare: https://mir-group.github.io/flare/installation/install.html)
2. See _Known issues_ at the bottom.
3. Contact me.


## Installation instruction

Create the conda environment:
```console
mamba create -yn sscha -c conda-forge python=3.9 git \
spglib=2.2 scipy pytest julia gfortran libblas lapack pip gcc gxx \
cmake openmp liblapacke openblas aiida-core aiida-core.services
mamba activate sscha
```

Clone the following packages under development:
```console
git clone -b new/flare-interface --depth 1 https://github.com/bastonero/python-sscha.git
git clone --depth 1 https://github.com/SSCHAcode/CellConstructor.git
```

One should also consider properly install AiiDA and making an AiiDA profile afterwards, and set computer and codes.

Install the SSCHA and its dependencies:
```console
pip install ase==3.22 julia setuptools==73.0
cd CellConstructor
pip install .
cd ../python-sscha
pip install .
pip install tdscha
```

The SSCHA benefits from julia to automatically speedup the calculation. Install the julia dependencies:
```console
python -c 'import julia; julia.install()'
```

Install torch and nequip:
```console
pip install pip install torch --index-url https://download.pytorch.org/whl/cpu
pip install nequip
```

FInally, reinstall ase and numpy enabling the OMP paralelization:
```console
pip install ase==3.22
pip install numpy==1.26 --force-reinstall
```

## Known issues

Usually, the known issues are:

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
