#!/usr/bin/env python
"""These are the two sequences to match"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '2.0.0'


lines = []
with open(r'/home/xiaosheng/CMEECourseWork/Week2/Data/DNA_Alignment.csv') as f:
    for line in f.readlines():
        lines.append(line.strip('\n'))

f.close()
seq1 = lines[0]
seq2 = lines[1]

f.close()
# seq2 = "ATCGCCGGATTACGGG"
# seq1 = "CAATTCGGAT"

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
    l1, l2 = l2, l1 # swap the two lengths

# function that computes a score
# by returning the number of matches 
# starting from arbitrary startpoint
def calculate_score(s1, s2, l1, l2, startpoint):
    # startpoint is the point at which we want to start
    matched = "" # contains string for alignement
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

for i in range(l1):
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2
        my_best_score = z



new_txt = open(r'/home/xiaosheng/CMEECourseWork/Week2/Data/DNA_Alignment Results.txt', 'w')
new_txt.write(my_best_align + '\n' + s1 + '\n' + "Best score:" + str(my_best_score))
new_txt.close()

 
# print (my_best_align + '\n')
# print (s1)
# print ("Best score:", my_best_score)