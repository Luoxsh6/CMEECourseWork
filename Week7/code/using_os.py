# !usr/bin/envs python3

__author__ = 'Xiaosheng Luo'
__version__ = '0.0.1'

"""This is subprocess"""

# Use the subprocess.os module to get a list of files and  directories
# in your ubuntu home directory

# Hint: look in subprocess.os and/or subprocess.os.path and/or
# subprocess.os.walk for helpful functions

import subprocess

#################################
# ~Get a list of files and
# ~directories in your home/ that start with an uppercase 'C'

# Type your code here:
p1 = subprocess.Popen(["ls"], stdout=subprocess.PIPE)
p2 = subprocess.Popen("grep ^C", stdin=p1.stdout,
                      stdout=subprocess.PIPE, shell=True)
stdout = p2.communicate()[0]
p1.stdout.close()
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
    for directory in subdir:
        if directory.lower().startswith("c"):
            FilesDirsStartingWithC.append(directory)
    for file in files:
        if file.lower().lower().startswith("c"):
            FilesDirsStartingWithC.append(file)
print("Get files and directories in home/ that start with either an upper or lower case 'C':\n\n",
      FilesDirsStartingWithC, "\n\n")
#################################
# Get only directories in your home/ that start with either an upper or
# ~lower case 'C'

# Type your code here:
FilesDirsStartingWithC = []
for (dir, subdir, files) in subprocess.os.walk(home):
    for directory in subdir:
        if directory.lower().startswith("c"):
            FilesDirsStartingWithC.append(directory)
print("Get only directories in home/ that start with either an upper or lower case 'C':\n\n",
      FilesDirsStartingWithC)
