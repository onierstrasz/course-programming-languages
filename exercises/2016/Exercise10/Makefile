SHELL=/bin/bash


MAIN=Exercise10-Prolog
BIB=references

SOURCES= \
	*.tex

quick: 
	pdflatex $(MAIN).tex
	@echo
	@echo "This is quick typeset!!! Consider 'make clean pdf'"

pdf: $(MAIN).pdf

ps: $(MAIN).ps


$(MAIN).bbl : $(MAIN).tex
	pdflatex $(MAIN).tex
	bibtex $(MAIN)


$(MAIN).pdf : $(MAIN).tex $(BIB).bib $(MAIN).bbl $(SOURCES) $(GRAPHS)
	pdflatex $(MAIN).tex
	pdflatex $(MAIN).tex


$(MAIN).ps : $(MAIN).tex $(BIB).bib  $(BIB).bbl ${SOURCES} ${GRAPHS}
	latex $(MAIN).tex
	latex $(MAIN).tex
	dvips $(MAIN).dvi -o $(MAIN).ps

clean : 
	rm -rf *~ text/*~ *.aux *.log *.blg $(MAIN).pdf $(MAIN).ps *.eps *.toc *.bbl *.dvi *.out *.bak
