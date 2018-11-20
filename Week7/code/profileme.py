#!/usr/bin/env python3

"""Examples of profiling"""

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

def my_squares(iters):
    """Compute the squre of the input and append to a list """
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out


def my_join(iters, string):
    """ Join inputs to a string for iters times """
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out


def run_my_funcs(x, y):
    """run the functions"""
    print(x, y)
    my_squares(x)
    my_join(x, y)
    return 0


run_my_funcs(10000000, "My string")
