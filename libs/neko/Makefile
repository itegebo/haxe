all: bytecode native

bytecode:
	ocamlc -I ../extlib -a -o neko.cma nast.ml nxml.ml binast.ml nbytecode.ml ncompile.ml

native:
	ocamlopt -I ../extlib -a -o neko.cmxa nast.ml nxml.ml binast.ml nbytecode.ml ncompile.ml

clean:
	rm -rf neko.cmxa neko.cma neko.lib neko.a $(wildcard *.cmo) $(wilcard *.cmx) $(wildcard *.obj) $(wildcard *.o) $(wildcard *.cmi)
