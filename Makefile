# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .

.PHONY: help clean html latexpdfja

help: ## show this help.
	@echo "Please use \`make <target>' where <target> is one of\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## to remove generated files
	-rm -rf $(BUILDDIR)/*

prepare: ## to prepare docker image for build with sphinx
	@docker build -t docsdockerjp/latex .

html: prepare ## to make standalone HTML files
	@docker run --rm -v `pwd`:/mnt docsdockerjp/latex make -f Makefile.docker clean html

latexpdfja: ## to make pdf files
	@grep -r '–' . | cut -d : -f 1 | grep -v -e Makefile -e README.md | sort | uniq | xargs -I%% perl -pi -e 's/–/--/g' "%%"
	@docker run --rm -v `pwd`:/mnt docsdockerjp/latex make -f Makefile.docker clean latexpdfja

serve: html ## to serve on nginx
	-docker stop docs.docker.jp
	docker run -it -d --rm --name "docs.docker.jp" -v "$(PWD)/$(BUILDDIR)/html:/usr/share/nginx/html/" -p "80:80" nginx
