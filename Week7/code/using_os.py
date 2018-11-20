""" This is blah blah"""

# Use the subprocess.os module to get a list of files and  directories
# in your ubuntu home directory

# Hint: look in subprocess.os and/or subprocess.os.path and/or
# subprocess.os.walk for helpful functions

import subprocess

#################################
# ~Get a list of files and
# ~directories in your home/ that start with an uppercase 'C'

# Type your code here:
p2 = subprocess.Popen("ls -l [C]*", shell=True, stdout=subprocess.PIPE)
stdout = p2.communicate()[0]
print(stdout.decode())


# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# # Create a list to store the results.
# FilesDirsStartingWithC = []

# # Use a for loop to walk through the home directory.
# for (dir, subdir, files) in subprocess.os.walk(home):

#################################
# Get files and directories in your home/ that start with either an
# upper or lower case 'C'

# Type your code here:
FilesDirsStartingWithC = []
for (dir, subdir, files) in subprocess.os.walk(home):
    for directory in dir:
        if directory.lower().startswith("c"):
            FilesDirsStartingWithC.append(directory)
    for file in files:
        if file.lower().lower().startswith("c"):
            FilesDirsStartingWithC.append(file)
print(FilesDirsStartingWithC)
#################################
# Get only directories in your home/ that start with either an upper or
# ~lower case 'C'

# Type your code here:
FilesDirsStartingWithC = []
for (dir, subdir, files) in subprocess.os.walk(home):
    for directory in dir:
        if directory.lower().startswith("c"):
            FilesDirsStartingWithC.append(directory)
print(FilesDirsStartingWithC)
