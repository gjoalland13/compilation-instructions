#!/bin/bash

export PYTHON_VENV_PATH=/home1/bastonero/builds/nequip

python -m venv $PYTHON_VENV_PATH
source $PYTHON_VENV_PATH/bin/activate
$PYTHON_VENV_PATH/bin/python -m pip install --upgrade pip

pip install torch==1.12.0+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
pip install nequip==0.5.6

# If you want an other branch:
# cd $PYTHON_VENV_PATH
# git clone -b stress --depth 1 https://github.com/mir-group/nequip.git nequip-src
# cd nequip-src && pip install .
# cd
