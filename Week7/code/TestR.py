#!/usr/bin/env python3

""" Run a R script with python and returns output or error """

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

import subprocess
subprocess.Popen("/usr/bin/Rscript --verbose ../sandbox/TestR.R > \
../results/TestR.Rout 2> ../results/TestR_errFile.Rout",
                 shell=True).wait()
