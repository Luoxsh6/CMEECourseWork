#!/usr/bin env python3

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '1.0.0'

""" Script that calculates tree height from distance and angle in a csv file
and outputs the with the heights to a new csv file """

from math import tan, pi


def TreeHeight(degrees=27, distance=27):
    """This functions calculates height of the tree from distance and angle of elevation"""
    radians = degrees * pi / 180
    height = distance * tan(radians)
    return (height)


def SaveNewfile(path='../data/trees.csv'):
    """This function strip the input path and save the data into a filename__treeheights.csv in results"""


TreeHeight()
