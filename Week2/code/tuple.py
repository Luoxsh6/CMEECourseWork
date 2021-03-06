#!/usr/bin/env python
"""Practical of tuple with list comprehension"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '0.0.1'

birds = (('Passerculus sandwichensis', 'Savannah sparrow', 18.7),
         ('Delichon urbica', 'House martin', 19),
         ('Junco phaeonotus', 'Yellow-eyed junco', 19.5),
         ('Junco hyemalis', 'Dark-eyed junco', 19.6),
         ('Tachycineata bicolor', 'Tree swallow', 20.2),
         )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species
# Hints: use the "print" command! You can use list comprehension!

# ANNOTATE WHAT EVERY BLOCK OR IF NECESSARY, LINE IS DOING!

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS


# use traditional loops
for i in range(len(birds)):
    print(birds[i])

# use list comprehension
[print(birds[i]) for i in range(len(birds))]
