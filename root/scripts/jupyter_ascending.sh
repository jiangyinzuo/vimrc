#!/bin/bash
name=$1

if [ -z "$name" ]
then
	echo "Please provide a name for the notebook"
	exit 1
fi

# if file doesn't exist
if [ ! -f "$name.ipynb" ]
then
	touch $name.ipynb
	ln -s $name.ipynb $name.sync.ipynb
	python3 -m jupyter_ascending.scripts.make_pair --base $name --force
fi

jupyter notebook $name.sync.ipynb --allow-root
