all: bytecode native

bytecode:
	ocamlc -g -I ../extlib -a -o java.cma jData.mli jReader.ml

native:
	ocamlopt -g -I ../extlib -a -o java.cmxa jData.mli jReader.ml
	
clean:
	rm -rf java.cma java.cmxa java.lib java.a $(wildcard *.cmo) $(wildcard *.cmx) $(wildcard *.obj) $(wildcard *.o) $(wildcard *.cmi)
