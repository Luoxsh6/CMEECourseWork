#!/usr/bin/env python3

"""A python version of Vectorize2.R, run the stochastic Ricker model using loop and vectorization"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '0.0.1'

# import modules
import numpy as np
import time


def stochrick(p0=np.random.uniform(.5, 1.5, size=1000), r=1.2, K=1, sigma=0.2, numyears=100):
    """Calculate the Ricker model with looping"""

    N = np.zeros((numyears, p0.shape[0]))  # initialize
    N[0, ] = p0[0]

    for pop in range(p0.shape[0]):  # loop through the populations
        for yr in range(1, numyears):  # for each pop, loop through the years
            N[yr, pop] = N[yr-1, pop] * \
                np.exp(r*(1-N[yr-1, pop]/K)) + np.random.normal(0, sigma, 1)

    return (N)


def stochrickvect(p0=np.random.uniform(.5, 1.5, size=1000), r=1.2, K=1, sigma=0.2, numyears=100):
    """Calculate the Ricker model with vectorization"""

    N = np.zeros((numyears, p0.shape[0]))  # initialize
    N[0, ] = p0[0]

    for yr in range(1, numyears):  # for each pop, loop through the years
        N[yr] = N[yr-1] * \
            np.exp(r*(1-N[yr-1]/K)) + np.random.normal(0, sigma, 1)

    return (N)


# time consuming comparison
# Loop verion
tic = time.time()
loop = stochrick()
toc = time.time()

print("Loop takes: " + str(1000*(toc - tic)) + " ms")

# vectorized version
tic = time.time()
vec = stochrickvect()
toc = time.time()

print("Vectorized takes: " + str(1000*(toc - tic)) + " ms")


# The np.exp function rises a overflow warning ignored by numpy setting.
np.seterr(all='ignore')
