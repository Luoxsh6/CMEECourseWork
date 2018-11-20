#!/usr/bin/env python3

"""Examples of profiling, optimized by using list comprehension and explicit string concatenation"""


__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

def my_squares(iters):
    """ Compute the squre of inputs using list comprehension"""
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters, string):
    """ Join inputs with explicit string concatenation """
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    """run the functions"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")