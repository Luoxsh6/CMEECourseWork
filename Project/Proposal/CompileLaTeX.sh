#!/bin/bash
# Author: Xiaosheng Luo
# Script: CompileLaTeX.sh
# Description: Colmpiles a pdf document from a tex file
#			   Opens the new pdf document


pdflatex Proposal.tex # Run pdflatex twice to compile the document
pdflatex Proposal.tex
bibtex Proposal		# Compiles the biblioraphy into the document
pdflatex Proposal.tex
pdflatex Proposal.tex
# evince Writeup.pdf & # Opens the pdf document

## Cleanup
rm *∼
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc
rm *.bbl
rm *.blg
# Removes extra unnecessary files.
