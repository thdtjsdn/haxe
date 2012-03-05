#!/bin/bash
MOTIONTWIN_CVS=":pserver:anonymous@cvs.motion-twin.com:/cvsroot"
CVS_COMMAND="cvs -z3 -d"
# neko
rm -rf neko/
svn export http://nekovm.googlecode.com/svn/trunk/libs/include/ocaml neko/libs/include/ocaml
# ocaml libs
rm -rf ocaml/
$CVS_COMMAND $MOTIONTWIN_CVS co ocaml/swflib
$CVS_COMMAND $MOTIONTWIN_CVS co ocaml/extc
$CVS_COMMAND $MOTIONTWIN_CVS co ocaml/extlib-dev
$CVS_COMMAND $MOTIONTWIN_CVS co ocaml/xml-light
