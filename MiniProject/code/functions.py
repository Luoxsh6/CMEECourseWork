#!/usr/bin/python

"""Necessary functions for data preprocessing and model fitting"""

__author__ = 'Xiaosheng Luo'
__version__ = '1.0.0'

# import modules
import cv2
import numpy as np


def read_img(filepath, size = (224,224)):
    """read and resize image file using opencv"""
    img = cv2.imread(filepath)
    img = cv2.resize(img, size)
    return img


# define images preprocessing functions
def extract_BGR_histogram(image):
    """extract a 3 color channels histogram from the BGR"""
    Hist = []
    for i in range(3):
        hist = cv2.calcHist([image],[i],None,[128],[0,256])
        Hist = np.append(Hist, hist) 

    # return the flattened histogram as the feature vector
    return Hist.flatten()

def extract_HSV_histogram(image):
    """extract a 3 color channels histogram from the HSV"""
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    Hist = []
    for i in range(3):
        hist = cv2.calcHist([hsv],[i],None,[128],[0,256])
        Hist = np.append(Hist, hist) 

    # return the flattened histogram as the feature vector
    return Hist.flatten()


def extract_HLS_histogram(image):
    """extract a 3 color channels histogram from the HLS"""
    hls = cv2.cvtColor(image, cv2.COLOR_BGR2HLS)
    Hist = []
    for i in range(3):
        hist = cv2.calcHist([hls],[i],None,[128],[0,256])
        Hist = np.append(Hist, hist) 

    # return the flattened histogram as the feature vector
    return Hist.flatten()


def create_mask_for_plant(image):
    """create a mask for the plants image base on threshold"""
    image_hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    # create threshold
    sensitivity = 35
    lower_hsv = np.array([60 - sensitivity, 100, 50])
    upper_hsv = np.array([60 + sensitivity, 255, 255])

    mask = cv2.inRange(image_hsv, lower_hsv, upper_hsv)
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (11,11))
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)
    return mask


def segment_plant(image):
    """segement out the plants images using the mask"""
    mask = create_mask_for_plant(image)
    output = cv2.bitwise_and(image, image, mask = mask)
    return output


def sharpen_image(image):
    """sharpen image"""
    image_blurred = cv2.GaussianBlur(image, (0, 0), 3)
    image_sharp = cv2.addWeighted(image, 1.5, image_blurred, -0.5, 0)
    return image_sharp