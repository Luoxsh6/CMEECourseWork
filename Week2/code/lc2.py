#!/usr/bin/env python
"""Practical of list comprehensions 2"""

__author__ = 'Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)'
__version__ = '0.0.1'

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
 
rainfall_over100 = [raintuples for raintuples in rainfall if raintuples[1] > 100]

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

rainmonth_less50 = [raintuples[0] for raintuples in rainfall if raintuples[1] < 50]

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

#1 
rainfall_over100 = []     #define and initialize a list
for raintuples in rainfall:
    if raintuples[1] > 100:
        rainfall_over100.append(raintuples)

#2
rainmonth_less50 = []     #define and initialize a list
for raintuples in rainfall:
    if raintuples[1] < 50:
        rainmonth_less50.append(raintuples[0])


# ANNOTATE WHAT EVERY BLOCK OR IF NECESSARY, LINE IS DOING! 

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT 
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS
