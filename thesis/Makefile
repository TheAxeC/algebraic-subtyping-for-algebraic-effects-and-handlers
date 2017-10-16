PY=python
PANDOC=pandoc

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/src
OUTPUTDIR=$(BASEDIR)/dst
OUTPUTDIRRES=$(OUTPUTDIR)/res
STYLEDIR=$(BASEDIR)/style
RESDIR=$(BASEDIR)/res

STYLEHTML=$(STYLEDIR)/html
STYLETEX=$(STYLEDIR)/tex
STYLEKUL=$(STYLEDIR)/kul

BIBDIR=$(BASEDIR)/bib
BIBFILE=$(BIBDIR)/references.bib

TEMPLATE=template
PREAMBLE=preamble
STYLE=style
REF_FORMAT=ref_format

PDF=pdf
TEX=tex
HTML=html
CSL=csl
CSS=css

THESIS_NAME=thesis

ALL_MD=$(wildcard $(INPUTDIR)/*.md)

EXCLUDES_PDF=title_page statement
EXCLUDES_PDF_WILDCARD=$(foreach EXL,$(EXCLUDES_PDF),$(wildcard $(INPUTDIR)/*$(EXL)*))
INPUT_PDF=$(filter-out $(EXCLUDES_PDF_WILDCARD), $(ALL_MD))

EXCLUDES_TEX=title_page statement
EXCLUDES_TEX_WILDCARD=$(foreach EXL,$(EXCLUDES_TEX),$(wildcard $(INPUTDIR)/*$(EXL)*))
INPUT_TEX=$(filter-out $(EXCLUDES_TEX_WILDCARD), $(ALL_MD))

EXCLUDES_HTML=
EXCLUDES_HTML_WILDCARD=$(foreach EXL,$(EXCLUDES_HTML),$(wildcard $(INPUTDIR)/*$(EXL)*))
INPUT_HTML=$(filter-out $(EXCLUDES_HTML_WILDCARD), $(ALL_MD))

STYLE_OUTPUT_KUL=$(BASEDIR)
KUL_FILES_TEX=$(wildcard $(STYLEKUL)/*)
KUL_FILES_COPY=$(patsubst $(STYLEKUL)%,$(STYLE_OUTPUT_KUL)%,$(KUL_FILES_TEX))

help:
	@echo ''
	@echo 'Makefile for the master thesis'
	@echo ''
	@echo 'Usage:'
	@echo '    make html          generate a web version'
	@echo '    make pdf           generate a PDF file'
	@echo '    make tex           generate a Latex file'
	@echo ''
	@echo 'Requirements:'
	@echo '    pandoc'
	@echo '    pandoc-citeproc'
	@echo '    pandoc-eqnos'

all: setup pdf tex html

setup:
	mkdir -p $(OUTPUTDIR)

pdf: setup
	cp $(KUL_FILES_TEX) $(STYLE_OUTPUT_KUL)
	pandoc $(INPUT_PDF) \
	--filter pandoc-eqnos \
	-o "$(OUTPUTDIR)/$(THESIS_NAME).$(PDF)" \
	-H "$(STYLETEX)/$(PREAMBLE).$(TEX)" \
	--template="$(STYLETEX)/$(TEMPLATE).$(TEX)" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLETEX)/$(REF_FORMAT).$(CSL)" \
	--highlight-style pygments \
	-V fontsize=12pt \
	-V papersize=a4paper \
	-V documentclass:report \
	-N \
	--latex-engine=xelatex \
	 2>pandoc.log
	 rm $(KUL_FILES_COPY)

tex: setup
	pandoc $(INPUT_TEX) \
	--filter pandoc-eqnos \
	-o "$(OUTPUTDIR)/$(THESIS_NAME).$(TEX)" \
	-H "$(STYLETEX)/$(PREAMBLE).$(TEX)" \
	--template="$(STYLETEX)/$(TEMPLATE).$(TEX)" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLETEX)/$(REF_FORMAT).$(CSL)" \
	--highlight-style pygments \
	-V fontsize=12pt \
	-V papersize=a4paper \
	-V documentclass:report \
	-N \
	--latex-engine=xelatex \
	 2>pandoc.log

html: setup
	pandoc $(INPUT_HTML) \
	-o "$(OUTPUTDIR)/$(THESIS_NAME).$(HTML)" \
	--filter pandoc-eqnos \
	--standalone \
	--template="$(STYLEHTML)/$(TEMPLATE).$(HTML)" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLEHTML)/$(REF_FORMAT).$(CSL)" \
	--include-in-header="$(STYLEHTML)/$(STYLE).$(CSS)" \
	--toc \
	--mathjax \
	--number-sections
	rm -rf "$(OUTPUTDIRRES)"
	mkdir "$(OUTPUTDIRRES)"
	cp -r "$(RESDIR)" "$(OUTPUTDIR)"

.PHONY: help pdf docx html tex
