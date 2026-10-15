#!/usr/bin/env bash
# Build the arXiv version (main_arxiv.tex) and pack an upload folder + tarball with only
# the files the build reads (taken from pdflatex's -recorder list), plus the .bbl.
# Output: arxiv_release/ and arxiv_release.tar.gz (upload the tarball to arXiv).
set -euo pipefail
cd "$(dirname "$0")"

pdflatex -interaction=nonstopmode -recorder main_arxiv >/dev/null
bibtex main_arxiv >/dev/null
pdflatex -interaction=nonstopmode -recorder main_arxiv >/dev/null
pdflatex -interaction=nonstopmode -recorder main_arxiv >/dev/null
if grep -q '^!' main_arxiv.log; then
  echo "LaTeX errors, see main_arxiv.log" >&2; exit 1
fi
grep -iq 'undefined references\|Citation .* undefined' main_arxiv.log && echo "warning: undefined references or citations" >&2

rm -rf arxiv_release arxiv_release.tar.gz
mkdir arxiv_release
# local inputs only (relative paths), skipping build products
grep '^INPUT ' main_arxiv.fls | cut -d' ' -f2- | grep -v '^/' | sed 's|^\./||' \
  | grep -v '\.\(aux\|out\|toc\|fls\)$' | sort -u \
  | while read -r f; do mkdir -p "arxiv_release/$(dirname "$f")"; cp "$f" "arxiv_release/$f"; done
cp main_arxiv.bbl arxiv_release/
cat > arxiv_release/00README.json <<'EOF'
{
   "sources" : [
      { "usage" : "toplevel", "filename" : "main_arxiv.tex" }
   ],
   "spec_version" : 1,
   "process" : { "compiler" : "pdflatex" }
}
EOF

# check that the package builds on its own
( cd arxiv_release && pdflatex -interaction=nonstopmode main_arxiv >/dev/null && pdflatex -interaction=nonstopmode main_arxiv >/dev/null ) \
  || { echo "arxiv_release does not build on its own" >&2; exit 1; }
rm -f arxiv_release/main_arxiv.{aux,log,out,pdf}
tar -czf arxiv_release.tar.gz -C arxiv_release .
echo "arxiv_release.tar.gz: $(find arxiv_release -type f | wc -l | tr -d ' ') files, $(du -h arxiv_release.tar.gz | cut -f1)"
