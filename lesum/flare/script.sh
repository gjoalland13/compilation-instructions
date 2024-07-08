#!/bin/bash

export PYTHON_VENV_PATH=/home1/bastonero/builds/flare

module load intel/oneapi-2023.1.0
module load compiler/2023.1.0 
module load mkl/2023.1.0

python -m venv $PYTHON_VENV_PATH
source $PYTHON_VENV_PATH/bin/activate
$PYTHON_VENV_PATH/bin/python -m pip install --upgrade pip

cd $PYTHON_VENV_PATH
git clone -b development --depth 1 https://github.com/mir-group/flare.git flare-src
cd flare-src && pip install .
cd ..

pip install --no-binary :all: numpy~=1.22.0 --force-reinstall
# rm -rf flare-src # remove the source folder
