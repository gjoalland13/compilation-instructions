# How to compile AiiDA + FLARE + SSCHA in a container/fresh computer

The easiest way is to use a MAMBA (a faster version of conda) environment.

These instructions should work out of the box. If you encounter any issue, you can:
1. Visit the official websites (flare: https://mir-group.github.io/flare/installation/install.html)
2. See _Known issues_ at the bottom.
3. Contact me.


## Installation instruction

Create the conda environment:
```console
conda create -yn fast -c conda-forge python=3.9 spglib=2.2 \
scipy pytest julia gfortran libblas lapack pip git clang_osx-64 \
clangxx_osx-64 cmake liblapacke openblas aiida-core aiida-core.services
conda activate fast
```

Clone the following packages under development:
```console
git clone -b development --depth 1 https://github.com/mir-group/flare.git
git clone -b new/flare-interface --depth 1 https://github.com/bastonero/python-sscha.git
git clone --depth 1 https://github.com/SSCHAcode/CellConstructor.git
```

Install aiida-quantumespresso and some other packages via pip:
```console
pip install aiida-quantumespresso aiida-pseudo ase==3.22 numpy spglib==2.2 scipy setuptools==73 julia pymatgen==2023.9.25
```
One should also consider properly install AiiDA and making an AiiDA profile afterwards, and set computer and codes.

Install flare:
```console
cd flare
pip install .
```

Install the SSCHA and its dependencies:
```console
cd ../CellConstructor
pip install .
cd ../python-sscha
pip install .
pip install tdscha
```

Finally, the SSCHA benefits from julia to automatically speedup the calculation. Install the julia dependencies:
```console
python -c 'import julia; julia.install()'
```


## Known issues

Usually, the known issues are:  
- When installing SSCHA using pip, you may encounter an error when building the PyCall and Conda julia dependencies. Usually, installing the other packages manually first and then the remaining two with the standard procedure will solve the problem. Proceed as follows:
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
- Regarding Linux compilation instructions, note that the `openmp`, `gcc`, and `gxx` compilers are not available on macOS and must be replaced respectively by `libomp`, `clang_osx-64`, and `clangxx_osx-64`. In the tutorial, we installed the `gcc` and `gxx` compilers in the Conda environment. As for the `libomp` compiler, it is not available in Conda and must be installed separately, e.g., via Homebrew:
    ```console
    brew install libomp
    echo export LDFLAGS="-L/usr/local/opt/libomp/lib" >> ~/.bash_profile
    echo export CPPFLAGS="-I/usr/local/opt/libomp/include" >> ~/.bash_profile
    ```
- For obscure reasons, it may be necessary to install the `gfortran` compiler both in the Conda environment and system-wide. We suggest using Homebrew to install it system-wide:
    ```console
    brew install gfortran
    ```