# !usr/bin/envs python3

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

"""The re practical"""

import re

# Read the file
f = open('../data/blackbirds.txt', 'r')
text = f.read()
f.close()

# remove \t\n and put a space in:
text = text.replace('\t',' ')
text = text.replace('\n',' ')

# note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform
# to ASCII:
# text = text.decode('ascii', 'ignore') #will not work in python 3

# Now extend this script so that it captures the Kingdom, 
# Phylum and Species name for each species and prints it out to screen neatly.
my_reg = r'(Kingdom)\s+([a-zA-Z]+)\s+.+?(Phylum)\s+([a-zA-Z]+)\s+.+?(Species)\s+([a-zA-Z]+\s[a-zA-Z]+)' 
Species = re.findall(my_reg, text)

for specie in Species:
    print(specie)

# Hint: you may want to use re.findall(my_reg, text)...
# Keep in mind that there are multiple ways to skin this cat! 
# Your solution may involve multiple regular expression calls (easier!), or a single one (harder!)