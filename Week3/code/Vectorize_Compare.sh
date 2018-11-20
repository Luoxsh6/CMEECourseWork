#!/bin/bash
# Script: Vectorize_Compare.sh
# Author: Xiaosheng Luo (xiaosheng.luo18@imperial.ac.uk)
# Desc: Compare computational speed between loop and vectorization
# Arguments: none
# Date: Oct 2018

echo -e "\n Computing time for Vectorize1.R \n"
Rscript Vectorize1.R
echo -e "-------------------------------------"
echo -e "\n Computing time for Vectorize1.py \n"
python3 Vectorize1.py
echo -e "-------------------------------------"
echo -e "\n Computing time for Vectorize2.R \n"
Rscript Vectorize2.R
echo -e "-------------------------------------"
echo -e "\n Computing time for Vectorize2.py \n"
python3 Vectorize2.py