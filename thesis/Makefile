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
STYLESPEC=$(STYLEDIR)/spec

BIBDIR=$(BASEDIR)/bib
BIBFILE=$(BIBDIR)/references.bib

TEMPLATE=template
PREAMBLE=preamble
STYLE=style
REF_FORMAT=acm-sig-proceedings

PDF=pdf
TEX=tex
HTML=html
CSL=csl
CSS=css

THESIS_NAME=thesis
SPEC_NAME=spec

ALL_MD=$(wildcard $(INPUTDIR)/*.md)
METADATA=$(INPUTDIR)/metadata.yaml

EXCLUDES_PDF=
EXCLUDES_PDF_WILDCARD=$(foreach EXL,$(EXCLUDES_PDF),$(wildcard $(INPUTDIR)/*$(EXL)*))
INPUT_PDF=$(filter-out $(EXCLUDES_PDF_WILDCARD), $(ALL_MD))

EXCLUDES_TEX=
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

all: setup spec spec-tex pdf tex html

setup:
	mkdir -p $(OUTPUTDIR)

spec: setup
	pandoc $(INPUT_PDF) $(METADATA) \
	--filter pandoc-eqnos \
	-o "$(OUTPUTDIR)/$(SPEC_NAME).$(PDF)" \
	-H "$(STYLESPEC)/$(PREAMBLE).$(TEX)" \
	--template="$(STYLESPEC)/$(TEMPLATE).$(TEX)" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLESPEC)/$(REF_FORMAT).$(CSL)" \
	--highlight-style pygments \
	# --top-level-division=chapter \
	-N \
	--latex-engine=xelatex \
	 2>pandoc.log

spec-tex: setup
	pandoc $(INPUT_PDF) $(METADATA) \
	--filter pandoc-eqnos \
	-o "$(OUTPUTDIR)/$(SPEC_NAME).$(TEX)" \
	-H "$(STYLESPEC)/$(PREAMBLE).$(TEX)" \
	--template="$(STYLESPEC)/$(TEMPLATE).$(TEX)" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLESPEC)/$(REF_FORMAT).$(CSL)" \
	--highlight-style pygments \
	# --top-level-division=chapter \
	-N \
	--latex-engine=xelatex \
	 2>pandoc.log

pdf: setup
	cp $(KUL_FILES_TEX) $(STYLE_OUTPUT_KUL)
	pandoc $(INPUT_PDF) $(METADATA) \
	--filter pandoc-eqnos \
	-o "$(OUTPUTDIR)/$(THESIS_NAME).$(PDF)" \
	-H "$(STYLETEX)/$(PREAMBLE).$(TEX)" \
	--template="$(STYLETEX)/$(TEMPLATE).$(TEX)" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLETEX)/$(REF_FORMAT).$(CSL)" \
	--highlight-style pygments \
	--top-level-division=chapter \
	-N \
	--latex-engine=xelatex \
	 2>pandoc.log
	 rm $(KUL_FILES_COPY)
	#  rm logokuleng-eps-converted-to.pdf

tex: setup
	pandoc $(INPUT_TEX) $(METADATA) \
	--filter pandoc-eqnos \
	-o "$(OUTPUTDIR)/$(THESIS_NAME).$(TEX)" \
	-H "$(STYLETEX)/$(PREAMBLE).$(TEX)" \
	--template="$(STYLETEX)/$(TEMPLATE).$(TEX)" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLETEX)/$(REF_FORMAT).$(CSL)" \
	--highlight-style pygments \
	--top-level-division=chapter \
	-N \
	--latex-engine=xelatex \
	 2>pandoc.log

html: setup
# 	pandoc $(INPUT_HTML) $(METADATA) \
# 	-o "$(OUTPUTDIR)/$(THESIS_NAME).$(HTML)" \
# 	--filter pandoc-eqnos \
# 	--standalone \
# 	--template="$(STYLEHTML)/$(TEMPLATE).$(HTML)" \
# 	--bibliography="$(BIBFILE)" \
# 	--csl="$(STYLEHTML)/$(REF_FORMAT).$(CSL)" \
# 	--include-in-header="$(STYLEHTML)/$(STYLE).$(CSS)" \
# 	--toc \
# 	--mathjax \
# 	--number-sections
# 	rm -rf "$(OUTPUTDIRRES)"
# 	mkdir "$(OUTPUTDIRRES)"
# 	cp -r "$(RESDIR)" "$(OUTPUTDIR)"

.PHONY: help pdf docx html tex
