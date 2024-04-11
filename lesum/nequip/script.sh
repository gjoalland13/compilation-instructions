#!/bin/bash

export PYTHON_VENV_PATH=/home1/bastonero/builds/nequip

python -m venv $PYTHON_VENV_PATH
source $PYTHON_VENV_PATH/bin/activate
$PYTHON_VENV_PATH/bin/python -m pip install --upgrade pip

pip install torch==1.12.0+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
pip install nequip==0.5.6
# If you want a specific branch (here called for demonstration `develop`):
# pip install git+https://github.com/mir-group/nequip.git@develop
