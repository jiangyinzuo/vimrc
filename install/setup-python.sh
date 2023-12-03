#!/bin/bash

. $(dirname $0)/setup-common.sh

soft_link_files+=( .condarc )

setup

# Docstring generator.
pip3 install doq --break-system-packages
