#!/usr/bin/env python
"""Practical of list comprehensions"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '0.0.1'


birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

latin_names = [bird[0] for bird in birds]
common_names = [bird[1] for bird in birds]
mean_body_masses = [bird[2] for bird in birds]    # using list comprehensions & index

# (2) Now do the same using conventional loops (you can shoose to do this 
# before 1 !). 

latin_names = []
common_names = []
mean_body_masses = []    # define and initialize three lists

for bird in birds:
    latin_names.append(bird[0])
    common_names.append(bird[1])
    mean_body_masses.append(bird[2])    # using loops & index
print (latin_names, '\n', common_names, '\n', mean_body_masses)



# ANNOTATE WHAT EVERY BLOCK OR IF NECESSARY, LINE IS DOING! 

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT 
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS.
