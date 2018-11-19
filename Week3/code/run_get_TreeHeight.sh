#!/bin/bash
# Author: Xiaosheng Luo xiaosheng.luo18@imperial.ac.uk
# Script: run_get_TreeHeight.sh
# Desc: simple boilerplate for shell scripts
# Arguments: none
# Date: Oct 2018

#!/bin/bash    

P1=$1  
  
DEFAULT_P1="../data/trees.csv"  

    
if [ "$P1" == "" ]; then  
    P1=$DEFAULT_P1  
fi  


Rscript get_TreeHeight.R $P1 
python3 get_TreeHeight.py $P1