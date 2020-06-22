# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = raas-garba
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

clean:
	@$(SPHINXBUILD) -M clean "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@mkdir -p "$(BUILDDIR)"/html/
	@find "$(SOURCEDIR)/year" -type l -delete

$(BUILDDIR)/html/.git:
	@cd $(BUILDDIR)/html; git init; git remote add origin git@github.com:raas-garba/raas-garba.github.io.git

push: html $(BUILDDIR)/html/.git
	@cd $(BUILDDIR)/html; git add .; git ci -m 'rebuilt docs'; git push --force -u origin master

links:
	@$(SOURCEDIR)/mklinks.py "$(SOURCEDIR)/year"

html: Makefile links
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@touch "$(BUILDDIR)"/html/.nojekyll

.PHONY: push clean help Makefile links html

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile links
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
