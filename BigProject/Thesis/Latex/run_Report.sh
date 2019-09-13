#!/bin/bash
# Author: xiaosheng.luo18@imperial.ac.uk
# Desc: t compile LaTeX
# Arguments: none

pdflatex Report.tex
pdflatex Report.tex
bibtex Report
pdflatex Report.tex
pdflatex Report.tex
