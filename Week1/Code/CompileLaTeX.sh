#!/bin/bash
name=`basename $1 .tex`
pdflatex $1
pdflatex $1
bibtex $name
pdflatex $1
pdflatex $1
evince $name.pdf &

##Cleanup

rm *.aux
rm *.bbl
rm *.log
rm *.blg

