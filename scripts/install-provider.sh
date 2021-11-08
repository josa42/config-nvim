#!/bin/bash

# python 2
python2 -m ensurepip --user # --default-pip
python2 -m pip install --user --upgrade pynvim

# python 3
python3 -m ensurepip --user
python3 -m pip install --user --upgrade pynvim

# ruby

# node
npm install -g neovim
