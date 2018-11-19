import re
MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a.academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a.academic@imperial.ac.uk, Some other stuff thats even more boring"

emails = re.findall(r'[\w\.-]+@[\w\.-]+', MyStr) 
for email in emails:
    print(email)

my_string = "a given string"
match = re.search(r'\s', my_string)
print(match)


MyStr = 'an example'
match = re.search(r'\w*\s', MyStr) # what pattern is this?
if match:                      
    print('found a match:', match.group()) 
else:
    print('did not find a match')

match = re.search(r'2' , "it takes 2 to tango")
match.group()

match = re.search(r'\d.*' , "it takes 2 to tango")
match.group()

match = re.search(r'\s\w{1,3}\s', 'once upon a time')
match.group()

match = re.search(r'\s\w*$', 'once upon a time')
match.group()

re.search(r'\w*\s\d.*\d', 'take 2 grams of H2O').group()

re.search(r'^\w*.*\s', 'once upon a time').group() # 'once upon a '

re.search(r'^\w*.*?\s', 'once upon a time').group()

re.search(r'<.+>', 'This is a <EM>first</EM> test').group()
re.search(r'<.+?>', 'This is a <EM>first</EM> test').group()


re.search(r'\d*\.?\d*','1432.75+60.22i').group()
re.search(r'[AGTC]+', 'the sequence ATTCGT').group()

re.search(r'\s+[A-Z]{1}\w+\s\w+', 'The bird-shit frog''s name is Theloderma asper').group()



MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w.@]+,\s[\w\s&]+",MyStr)
match.group()

match = re.search(r"([\w\s]+),\s([\w\.@]+),\s([\w\s&]+)",MyStr)
if match:
    print(match.group(0))
    print(match.group(1))
    print(match.group(2))
    print(match.group(3))


f = open('../data/TestOaksData.csv', 'r')


re.search(r'^((19[0-9]+)|([2-9]+)){4}\d{1,2}\d{1,2}$', '20181113').group()

re.search(r'^((19[0-9]{2})|([2-9]\d{3}))[01]\d{1}[0123]\d{1}$','20180133').group()


MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a.academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a.academic@imperial.ac.uk, Some other stuff thats even more boring"
emails = re.findall(r'[\w\.-]+@[\w\.-]+', MyStr) 
for email in emails:
    print(email)


f = open('../data/TestOaksData.csv', 'r')
strings = re.findall(r'O.+', f.read())
strings


MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a.academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a.academic@imperial.ac.uk, Some other stuff thats even more boring"
tuples = re.findall(r'([\w\.-]+)@([\w\.-]+)', MyStr)
print(tuples)
for tuple in tuples:
    print(tuple[0])
    print(tuple[1])


import re
import urllib3

http = urllib3.PoolManager()
r = http.request('GET', 'https://www.imperial.ac.uk/silwood-park/academic-staff/')
html = r.data