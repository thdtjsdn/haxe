# Makefile generated by OCamake 
# http://tech.motion-twin.com
.SUFFIXES : .ml .mli .cmo .cmi .cmx .mll .mly

CFLAGS= -I ../neko/libs/include/ocaml
LIBS=extLib.cmxa extc.cmxa swfLib.cmxa unix.cmxa
LFLAGS= -o haxe.exe -I ../neko/libs/include/ocaml
OUTPUT=sed 's/File "\([^"]\+\)", line \([0-9]\+\), \(.*\)/\1(\2): \3/' tmp.cmi

all: haxe.exe

haxe.exe: ../neko/libs/include/ocaml/nast.cmx ast.cmx plugin.cmx ../neko/libs/include/ocaml/nxml.cmx lexer.cmx type.cmx genswf9.cmx parser.cmx transform.cmx typer.cmx genneko.cmx genjs.cmx genswf.cmx genxml.cmx main.cmx
	ocamlopt $(LFLAGS) $(LIBS) ../neko/libs/include/ocaml/nast.cmx ast.cmx plugin.cmx ../neko/libs/include/ocaml/nxml.cmx lexer.cmx type.cmx parser.cmx transform.cmx typer.cmx genneko.cmx genjs.cmx genswf9.cmx genswf.cmx genxml.cmx main.cmx

genneko.cmx: typer.cmx type.cmx plugin.cmx ../neko/libs/include/ocaml/nxml.cmx ../neko/libs/include/ocaml/nast.cmx lexer.cmx ast.cmx

../neko/libs/include/ocaml/nxml.cmx: ../neko/libs/include/ocaml/nast.cmx

genjs.cmx: typer.cmx type.cmx transform.cmx ast.cmx

genswf.cmx: typer.cmx type.cmx transform.cmx plugin.cmx genswf9.cmx ast.cmx

genswf9.cmx: type.cmx ast.cmx typer.cmx transform.cmx

genxml.cmx: typer.cmx type.cmx lexer.cmx ast.cmx

lexer.cmx: lexer.ml

lexer.cmx: ast.cmx

main.cmx: typer.cmx plugin.cmx parser.cmx lexer.cmx genxml.cmx genswf.cmx genneko.cmx genjs.cmx ast.cmx

parser.cmx: parser.ml plugin.cmx lexer.cmx ast.cmx
	(ocamlopt -pp camlp4o $(CFLAGS) -c parser.ml 2>tmp.cmi && $(OUTPUT)) || ($(OUTPUT) && exit 1)

transform.cmx: type.cmx

type.cmx: ast.cmx

typer.cmx: type.cmx plugin.cmx parser.cmx lexer.cmx ast.cmx

clean:
	rm -f haxe.exe
	rm -f typer.obj typer.cmx typer.cmi type.obj type.cmx type.cmi transform.obj transform.cmx transform.cmi plugin.obj plugin.cmx plugin.cmi parser.obj parser.cmx parser.cmi main.obj main.cmx main.cmi lexer.obj lexer.cmx lexer.cmi lexer.ml genxml.obj genxml.cmx genxml.cmi genswf9.obj genswf9.cmx genswf9.cmi genswf.obj genswf.cmx genswf.cmi genjs.obj genjs.cmx genjs.cmi ast.obj ast.cmx ast.cmi ../neko/libs/include/ocaml/nxml.obj ../neko/libs/include/ocaml/nxml.cmx ../neko/libs/include/ocaml/nxml.cmi ../neko/libs/include/ocaml/nast.obj ../neko/libs/include/ocaml/nast.cmx ../neko/libs/include/ocaml/nast.cmi genneko.obj genneko.cmx genneko.cmi

# SUFFIXES
.ml.cmo:
	ocamlc $(CFLAGS) -c $<

.ml.cmx:
	(ocamlopt $(CFLAGS) -c $< 2>tmp.cmi && $(OUTPUT)) || ($(OUTPUT) && exit 1)

.mli.cmi:
	ocamlc $(CFLAGS) $<

.mll.ml:
	ocamllex $<

.mly.ml:
	ocamlyacc $<

