#!/bin/bash

export PYTHON_VENV_PATH=/home1/bastonero/builds/flare

python -m venv $PYTHON_VENV_PATH
source $PYTHON_VENV_PATH/bin/activate
$PYTHON_VENV_PATH/bin/python -m pip install --upgrade pip

cd $PYTHON_VENV_PATH
git clone -b development --depth 1 https://github.com/mir-group/flare.git flare-src
cd flare-src && pip install .
cd ..
# rm -rf flare-src # remove the source folder
