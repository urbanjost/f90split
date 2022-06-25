#!/bin/bash
# position at top of fpm project
cd $(dirname $0)/..
# preprocess Fortran source
(
cd app
prep F90 TESTPRG90 --noenv --comment doxygen --verbose -i f90split.ff -o f90split.f90
)
# build and install
fpm install
# generate documentation with ford(1)
ford ford.md
#  generate man page and install
read NAME VERSION OTHER <<< $(f90split --version|grep VERSION:|tail -n 1)
mkdir -p $HOME/.local/man/man1/ man/man1
f90split --help|
   txt2man -t f90split -r "f90split-${VERSION}" -s 1 -v "fpm Fortran tools" >man/man1/f90split.1
# nroff -man man/man1/f90split.1|less -r
cp man/man1/f90split.1 $HOME/.local/man/man1/
# generate markdown help text
pandoc --from=man --to=markdown_mmd --output=docs/f90split.md <man/man1/f90split.1
exit
