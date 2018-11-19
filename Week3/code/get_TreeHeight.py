#!/usr/bin/env python3

"""A function calculates heights of trees given distance of each tree from its base and angle to its top, using the trigonometric formula"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '0.0.1'

# import modules
import sys
import pandas as pd
import numpy as np
import ntpath


def TreeHeight(data):
    """Calculate treeheights from distance and angle of elevation. Input(degrees, distance), output height"""

    degrees = data['Angle.degrees']
    distance = data['Distance.m']
    radians = np.deg2rad(degrees)
    height = distance * np.tan(radians)
    data['height'] = height
    return data


def ReadFile(inputpath):
    """Read and load file from path fpath, and return pandas data"""

    data = pd.read_csv(inputpath)
    return data


def SaveFile(outputdata, inputpath):
    """Save data into a '../results' directory with filename InputFileName_treeheights.csv"""

    name = ntpath.basename(inputpath).split('.')[0]
    filename = name + r'_treeheights.csv'
    path = '../results/' + filename
    outputdata.to_csv(path, index=False)


def main(argv):
    data = ReadFile(sys.argv[1])
    outputdata = TreeHeight(data)
    SaveFile(outputdata, sys.argv[1])


if(__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit("Exit")
