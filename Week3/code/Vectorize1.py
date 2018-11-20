#!/usr/bin/env python3

"""A python version of Vectorize1.R, sums all elements in a matrix using loop and vectorization"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '0.0.1'

# import modules
import numpy as np
import time


def SumbyLoop(M):
    """sum matrix elements by loop"""
    Tot = 0
    for i in range(M.shape[0]):
        for j in range(M.shape[1]):
            Tot += M[i][j]
    return Tot


def SumbyVec(M):
    """sum matrix elements by vectorization"""
    Tot = np.sum(M)
    return Tot


# initialize matrix M
np.random.seed(27)
M = np.random.rand(1000, 1000)

# time consuming comparison
# Loop verion
tic = time.time()
loop = SumbyLoop(M)
toc = time.time()

print("Looping sum is:", loop)
print("Loop takes: " + str(1000*(toc - tic)) + " ms")

# vectorized version
tic = time.time()
vec = SumbyVec(M)
toc = time.time()

print("Vectorized sum is:", vec)
print("Vectorized takes: " + str(1000*(toc - tic)) + " ms")
