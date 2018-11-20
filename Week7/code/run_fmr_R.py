#!/usr/bin/env python3

"""Run fmr.R"""

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'


import subprocess

p = subprocess.Popen("Rscript fmr.R", stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE, shell=True)

stdout, stderr = p.communicate()

if stderr:
    print("Error!!\n")
    print(stderr.decode())
else:
    print("Successfully call Rscript fmr.R\n")

print(stdout.decode())
