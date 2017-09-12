#!/bin/bash

# This script is meant to be sourced, so we can easily setup a virtualenv with ansible for testing
# with Vagrant.
#
ENVNAME=${ENVNAME:-"test/ansible_venv"}

if ! test -d "$ENVNAME"; then
    virtualenv "$ENVNAME"
fi

source "$ENVNAME/bin/activate"
pip install -r test/requirements.txt
