#!/bin/bash
# Author: xiaosheng.luo18@imperial.ac.uk
# Desc: compile LaTeX
# Arguments: none
# Date: July 2019

pdflatex Diary.tex
pdflatex Diary.tex
bibtex Diary
pdflatex Diary.tex
pdflatex Diary.tex

rm *.aux
rm *.bbl
rm *.blg
rm *.log
rm *.fls
rm *.fdb_latexmk