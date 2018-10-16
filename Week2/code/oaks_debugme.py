import csv
import sys
import pdb
import re
# Define function


def is_an_oak(name):
    """ Returns True if name is starts with 'quercus'

    >>> is_an_oak('Fagus sylvatica')
    False

    >>> is_an_oak('Quercus robur')
    True

    >>> is_an_oak('Quercuss cerris')
    False
    """

    if re.match('^quercus\s', name, flags=re.I) != None:
        return True
    else:
        return False


def main(argv):
    f = open('../Data/TestOaksData.csv', 'r')
    g = open('../Data/JustOaksData.csv', 'w')
    taxa = csv.reader(f)
    header = next(taxa)
    csvwrite = csv.writer(g)
    csvwrite.writerow(header)
    oaks = set()
    for row in taxa:
        print(row)
        print("The genus is: ")
        print(row[0] + '\n')
        if is_an_oak(row[0] + ' '):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])

    return 0


if (__name__ == "__main__"):
    status = main(sys.argv)


# import doctest
# doctest.testmod()
