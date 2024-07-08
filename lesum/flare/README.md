# FLARE on LESUM

## Installation

Copy/paste `script.sh` on LESUM and modify where needed. It should work straight out of the box.

### Useful commands

Few useful commands:
1. python -c "import numpy as np; print(np.__config__.show())" (this should report some MKL words)
2. ldd ~/flare/lib/python3.9/site-packages/flare/bffs/sgp/_C_flare.cpython-39-x86_64-linux-gnu.so (this one too)
3. ldd ~/flare/lib/python3.9/site-packages/numpy/core/_multiarray_umath.cpython-39-x86_64-linux-gnu.so (this one too)
4. pip install --no-binary :all: numpy~=1.22.0 --force-reinstall (after loading the MKL modules; should link it straight, but verify with previous commands)

## Usage

The `submit.sh` shows how to call FLARE using Quantum ESPRESSO scripts. Example of inputs for `flare-otf` can be found [here](https://github.com/mir-group/flare/tree/master/examples).