#!/usr/bin/env python
"""Some foo functions"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '1.0.0'

import sys


def foo1(x=4):
    """Calculate the square root"""
    return x ** 0.5


def foo2(x=3, y=4):
    """Find the bigger number"""
    if x > y:
        return x
    return y


def foo3(x=9, y=8, z=7):
    """Sort from samll to large"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]


def foo4(x=3):
    """Multiply from 1 to x"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result


def foo5(x=9):
    """A recursive function Multiply from x to 1"""
    if x == 1:
        return 1
    return x * foo5(x - 1)


def main(argv):
    print(foo1(1))
    print(foo2(2, 3))
    print(foo3(4, 5, 6))
    print(foo4(7))
    print(foo5(8))
    return 0


if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
