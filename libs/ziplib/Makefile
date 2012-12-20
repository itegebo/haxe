all: bytecode native

bytecode:
	ocamlc -g -I ../extlib -I ../extc -a -o zip.cma zlib.mli zlib.ml zip.mli zip.ml

native:
	ocamlopt -g -I ../extlib -I ../extc -a -o zip.cmxa zlib.mli zlib.ml zip.mli zip.ml
	
clean:
	rm -rf zip.cma zip.cmxa zip.lib zip.a $(wildcard *.cmo) $(wildcard *.cmx) $(wildcard *.obj) $(wildcard *.o) $(wildcard *.cmi)
