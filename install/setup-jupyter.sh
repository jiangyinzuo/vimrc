PY=python3

# Jupyter Ascending
# https://github.com/untitled-ai/jupyter_ascending
#
# Edit Jupyter notebooks from vim, then instantly sync and execute that code
# in the Jupyter notebook running in your browser.
#
# jupyter_ascending currently does not support notebook 7
# See: https://alpha2phi.medium.com/jupyter-notebook-vim-neovim-c2d67d56d563#c0ed
pip3 install jupyter_ascending $1  && \
$PY -m jupyter nbextension    install jupyter_ascending --sys-prefix --py && \
$PY -m jupyter nbextension     enable jupyter_ascending --sys-prefix --py && \
$PY -m jupyter serverextension enable jupyter_ascending --sys-prefix --py

