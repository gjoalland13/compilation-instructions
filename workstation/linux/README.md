# How to compile NEQUIP + AiiDA + SSCHA in a container/fresh computer

Using a MAMBA (a faster version of conda) environment is the easiest way.

These instructions should work out of the box. If you encounter any issue, you can:
1. See _Known issues_ at the bottom.
2. Visit the other compilation instructions
3. Contact me.


## Installation instruction

Create the conda environment:
```console
mamba create -yn sscha-nequip -c conda-forge python=3.9 git \
spglib=2.2 scipy pytest julia gfortran libblas lapack pip gcc gxx \
cmake openmp liblapacke openblas aiida-core aiida-core.services
mamba activate sscha-nequip
```

Clone the following packages under development:
```console
git clone -b new/flare-interface --depth 1 https://github.com/bastonero/python-sscha.git
git clone --depth 1 https://github.com/SSCHAcode/CellConstructor.git
```

Install Pytorch (needed for NequIP):
```console
conda install -yn sscha-nequip -c conda-forge pytorch~=1.12.1 pytorch-cpu~=1.12.1
```

Install aiida-quantumespresso, NequIP and some other packages via pip:
```console
pip install ase==3.22 julia aiida-quantumespresso aiida-pseudo nequip
```

One should also consider properly installing AiiDA, making an AiiDA profile afterwards, and setting computer and codes.


Install the SSCHA and its dependencies:
```console
cd CellConstructor
python setup.py install
cd ../python-sscha
python setup.py install
pip install tdscha
```

Finally, the SSCHA benefits from julia to automatically speed up the calculation. Install the julia dependencies:
```console
python -c 'import julia; julia.install()'
```

## Known issues

Usually, the known issues are:

- NequIP CPU only would probably crash if you also install torch-vision and torch-audio. Just don't install them, they are not needed anyways.
  
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
