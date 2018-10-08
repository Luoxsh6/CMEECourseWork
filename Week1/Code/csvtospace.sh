#!/bin/bash
# Author: xiaosheng.luo18@imperial.ac.uk
# Script: csvtospace.sh
# Desc: takes a comma separated values and converts it to a space separated values
# Arguments: csv file
# Date: Oct 2018

echo "Converting to a space separated file"
cat $1 | tr -s "," " " > $2
echo "Done!"

exit