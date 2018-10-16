#!/usr/bin/env python
"""These are the two sequences to match and ouput all the best alignment"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '2.0.0'

import sys
import pickle
import os

# initialize two sequences
lines1 = ""
lines2 = ""

# find the inputfile name and read the sequences
if len(sys.argv) > 1:

    File1_direction = r'../data/' + sys.argv[1]
    File2_direction = r'../data/' + sys.argv[2]

    with open(File1_direction) as f1:
        next(f1)
        for line in f1.readlines():
            lines1 += line
    f1.close()

    with open(File2_direction) as f2:
        next(f2)
        for line in f2.readlines():
            lines2 += line
    f2.close()

    seq1 = lines1.replace('\n', '')
    seq2 = lines2.replace('\n', '')

else:
    seq2 = "ATCGCCGGATTACGGG"
    seq1 = "CAATTCGGAT"

# assign the longest sequence s1, and the shortest to s2
# l1 is the length of the longest, l2 that of the shortest
l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1  # swap the two lengths


# function that computes a score
# by returning the number of matches
# starting from arbitrary startpoint
def calculate_score(s1, s2, l1, l2, startpoint):
    # startpoint is the point at which we want to start
    matched = ""  # contains string for alignement
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            # if its matching the character
            if s1[i + startpoint] == s2[i]:
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # build some formatted output
    # print ("." * startpoint + matched)
    # print ("." * startpoint + s2)
    # print (s1)
    # print (score)
    # print ("")

    return score


# now try to find the best match (highest score)
my_best_align = None
my_best_score = -1
best_align_num = 0  # count the best alignment numbers
# create a new txt file to store all best results
f = open('pickle.txt', 'wb+')

for i in range(l1):
    z = calculate_score(s1, s2, l1, l2, i)
    if z >= my_best_score:
        best_align_num += 1
        my_best_align = "." * i + s2
        my_best_score = z
        pickle.dump(my_best_align, f, 0)
f.close()

#  write the best results into the DNA_Alignment_Results.txt using loops
f = open('pickle.txt', 'rb+')
new_txt = open(r'../data/DNA_Alignment_Results.txt', 'w')

for i in range(best_align_num):
    new_txt.write(pickle.load(f) + '\n' + s1 + '\n' +
                  "Best score:" + str(my_best_score) + '\n' + '\n')

f.close()
new_txt.close()

# delete the temporary pickle file
os.remove('pickle.txt')
