#!/usr/bin/env python3

"""Run LV scripts"""

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

import subprocess

print("profileing LV1.py\n")
subprocess.os.system("python -m cProfile LV1.py")
print("profileing LV2.py\n")
subprocess.os.system("python -m cProfile LV2.py")
print("profileing LV3.py\n")
subprocess.os.system("python -m cProfile LV3.py")
print("profileing LV4.py\n")
subprocess.os.system("python -m cProfile LV4.py")
