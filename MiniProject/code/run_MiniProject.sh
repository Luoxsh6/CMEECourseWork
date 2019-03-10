#!/bin/bash
# Author: xiaosheng.luo18@imperial.ac.uk
# Desc: test the script and compile LaTeX
# Arguments: none
# Date: March 2019

echo -e "\nInstall some necessary packages\n"
sudo pip3 install opencv-python
sudo pip3 install sklearn
sudo pip3 install xgboost
echo -e "\nRunning Script, it takes about 2 min, please take a sip of tea\n"
python3.6 modelfitting.py

echo -e "\nGenerate Report\n"

pdflatex Report.tex
pdflatex Report.tex
bibtex Report
pdflatex Report.tex
pdflatex Report.tex

mv ./Report.pdf ../results

echo -e "\nPlease see the report in the results, thank you very much!\n"
