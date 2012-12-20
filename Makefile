# Haxe compiler Makefile
#
#  - use 'make' to build all
#  - use 'make haxe' to build only the compiler (not the libraries)
#  - if you want to build quickly, install 'ocamlopt.opt' and change OCAMLOPT=ocamlopt.top
#
#  Windows users :
#  - use 'make -f Makefile.win' to build for Windows
#  - use 'make MSVC=1 -f Makefile.win' to build for Windows with OCaml/MSVC
#
.SUFFIXES : .ml .mli .cmo .cmi .cmx .mll .mly

OUTPUT=haxe
EXTENSION=
OCAMLOPT=ocamlopt.opt
OCAMLC=ocamlc.opt

CFLAGS= -g -I libs/extlib -I libs/extc -I libs/neko -I libs/javalib -I libs/ziplib -I libs/swflib -I libs/xml-light

NATIVE_CC_CMD = $(OCAMLOPT) $(CFLAGS) -c $<
BYTE_CC_CMD = $(OCAMLC) $(CFLAGS) -c $<
NATIVE_CC_PARSER_CMD = $(OCAMLOPT) -pp camlp4o $(CFLAGS) -c parser.ml
BYTE_CC_PARSER_CMD = $(OCAMLC) -pp camlp4o $(CFLAGS) -c parser.ml

NATIVE_LIBS=unix.cmxa str.cmxa libs/extlib/extLib.cmxa libs/xml-light/xml-light.cmxa libs/swflib/swflib.cmxa \
	libs/extc/extc.cmxa libs/neko/neko.cmxa libs/javalib/java.cmxa libs/ziplib/zip.cmxa

BYTE_LIBS=unix.cma str.cma libs/extlib/extLib.cma libs/xml-light/xml-light.cma libs/swflib/swflib.cma \
	libs/extc/extc.cma libs/neko/neko.cma libs/javalib/java.cma libs/ziplib/zip.cma

EXTERNAL_NATIVE_LIBS=-cclib libs/extc/extc_stubs.o -cclib -lz

RELDIR=../../..

EXPORT=../../../projects/motionTools/haxe

MODULES=ast type lexer common genxml parser typecore optimizer typeload \
	codegen genas3 gencommon gencpp genjs genneko genphp genswf8 \
	gencs genjava genswf9 genswf interp typer dce main

HAXE_LIBRARY_PATH=$(CURDIR)/std

all: libs haxe haxe.byte tools

libs:
	make -C libs/extlib all opt
	make -C libs/extc all
	make -C libs/neko all
	make -C libs/javalib all
	make -C libs/ziplib all
	make -C libs/swflib all
	make -C libs/xml-light all

haxe: $(MODULES:=.cmx)
	$(OCAMLOPT) -o $(OUTPUT) $(EXTERNAL_NATIVE_LIBS) $(NATIVE_LIBS) $(MODULES:=.cmx)

haxe.byte: $(MODULES:=.cmo)
	$(OCAMLC) -custom -o $(OUTPUT).byte $(EXTERNAL_NATIVE_LIBS) $(BYTE_LIBS) $(MODULES:=.cmo)

haxelib:
	$(CURDIR)/$(OUTPUT) --cwd "$(CURDIR)/std/tools/haxelib" haxelib.hxml
	cp std/tools/haxelib/haxelib$(EXTENSION) haxelib$(EXTENSION)

haxedoc:
	$(CURDIR)/$(OUTPUT) --cwd "$(CURDIR)/std/tools/haxedoc" haxedoc.hxml
	cp std/tools/haxedoc/haxedoc$(EXTENSION) haxedoc$(EXTENSION)

tools: haxelib haxedoc

export:
	cp haxe*.exe doc/CHANGES.txt $(EXPORT)
	rsync -a --exclude .svn --exclude *.n --exclude std/libs --delete std $(EXPORT)

codegen.cmx: typeload.cmx typecore.cmx type.cmx genxml.cmx common.cmx ast.cmx

common.cmx: type.cmx ast.cmx

dce.cmx: ast.cmx common.cmx type.cmx

genas3.cmx: type.cmx common.cmx codegen.cmx ast.cmx

gencommon.cmx: type.cmx common.cmx codegen.cmx ast.cmx

gencpp.cmx: type.cmx lexer.cmx common.cmx codegen.cmx ast.cmx

gencs.cmx: type.cmx lexer.cmx gencommon.cmx common.cmx codegen.cmx ast.cmx

genjava.cmx: type.cmx gencommon.cmx common.cmx codegen.cmx ast.cmx

genjs.cmx: type.cmx optimizer.cmx lexer.cmx common.cmx codegen.cmx ast.cmx

genneko.cmx: type.cmx lexer.cmx common.cmx codegen.cmx ast.cmx

genphp.cmx: type.cmx lexer.cmx common.cmx codegen.cmx ast.cmx

genswf.cmx: type.cmx genswf9.cmx genswf8.cmx common.cmx ast.cmx

genswf8.cmx: type.cmx lexer.cmx common.cmx codegen.cmx ast.cmx

genswf9.cmx: type.cmx lexer.cmx genswf8.cmx common.cmx codegen.cmx ast.cmx

genxml.cmx: type.cmx lexer.cmx common.cmx ast.cmx

interp.cmx: typecore.cmx type.cmx lexer.cmx genneko.cmx common.cmx codegen.cmx ast.cmx genswf.cmx parser.cmx

main.cmx: dce.cmx typer.cmx typeload.cmx typecore.cmx type.cmx parser.cmx optimizer.cmx lexer.cmx interp.cmx genxml.cmx genswf.cmx genphp.cmx genneko.cmx genjs.cmx genjava.cmx gencs.cmx gencpp.cmx genas3.cmx common.cmx codegen.cmx ast.cmx

optimizer.cmx: typecore.cmx type.cmx parser.cmx common.cmx ast.cmx

parser.cmx: parser.ml lexer.cmx common.cmx ast.cmx
	$(NATIVE_CC_PARSER_CMD)

parser.cmo: parser.ml lexer.cmo common.cmo ast.cmo
	$(BYTE_CC_PARSER_CMD)

type.cmx: ast.cmx

typecore.cmx: type.cmx common.cmx ast.cmx

typeload.cmx: typecore.cmx type.cmx parser.cmx optimizer.cmx lexer.cmx common.cmx ast.cmx

typer.cmx: typeload.cmx typecore.cmx type.cmx parser.cmx optimizer.cmx lexer.cmx interp.cmx genneko.cmx genjs.cmx common.cmx codegen.cmx ast.cmx

lexer.cmx: lexer.ml

lexer.cmx: ast.cmx

codegen.cmo: typeload.cmo typecore.cmo type.cmo genxml.cmo common.cmo ast.cmo
common.cmo: type.cmo ast.cmo
dce.cmo: type.cmo common.cmo ast.cmo
genas3.cmo: type.cmo common.cmo codegen.cmo ast.cmo
gencommon.cmo: type.cmo common.cmo codegen.cmo ast.cmo
gencpp.cmo: type.cmo lexer.cmo common.cmo codegen.cmo ast.cmo
gencs.cmo: type.cmo gencommon.cmo common.cmo ast.cmo
genjava.cmo: type.cmo gencommon.cmo common.cmo codegen.cmo ast.cmo
genjs.cmo: type.cmo optimizer.cmo lexer.cmo common.cmo codegen.cmo ast.cmo
genneko.cmo: type.cmo lexer.cmo common.cmo codegen.cmo ast.cmo
genphp.cmo: type.cmo lexer.cmo common.cmo codegen.cmo ast.cmo
genswf8.cmo: type.cmo lexer.cmo common.cmo codegen.cmo ast.cmo
genswf9.cmo: type.cmo lexer.cmo genswf8.cmo common.cmo codegen.cmo ast.cmo
genswf.cmo: type.cmo genswf9.cmo genswf8.cmo common.cmo ast.cmo
genxml.cmo: type.cmo lexer.cmo common.cmo ast.cmo
interp.cmo: typecore.cmo type.cmo parser.cmo lexer.cmo genswf.cmo genneko.cmo \
    common.cmo ast.cmo
lexer.cmo: ast.cmo
main.cmo: typer.cmo typeload.cmo typecore.cmo type.cmo parser.cmo \
    optimizer.cmo lexer.cmo interp.cmo genxml.cmo genswf.cmo genphp.cmo \
    genneko.cmo genjs.cmo genjava.cmo gencs.cmo gencpp.cmo genas3.cmo dce.cmo \
    common.cmo codegen.cmo ast.cmo
optimizer.cmo: typecore.cmo type.cmo parser.cmo common.cmo ast.cmo
typecore.cmo: type.cmo common.cmo ast.cmo
typeload.cmo: typecore.cmo type.cmo parser.cmo optimizer.cmo lexer.cmo \
    common.cmo ast.cmo
type.cmo: ast.cmo
typer.cmo: typeload.cmo typecore.cmo type.cmo parser.cmo optimizer.cmo \
    lexer.cmo interp.cmo genneko.cmo genjs.cmo common.cmo codegen.cmo ast.cmo

clean: clean_libs clean_haxe clean_tools

clean_libs:
	make -C libs/extlib clean
	make -C libs/extc clean
	make -C libs/neko clean
	make -C libs/ziplib clean
	make -C libs/javalib clean
	make -C libs/swflib clean
	make -C libs/xml-light clean

clean_haxe:
	rm -f $(MODULES:=.obj) $(MODULES:=.o) $(MODULES:=.cmx) $(MODULES:=.cmi) $(MODULES:=.cmo) lexer.ml

clean_tools:
	rm -f $(OUTPUT) haxelib haxedoc

# SUFFIXES
.ml.cmx:
	$(NATIVE_CC_CMD)

.mli.cmi:
	$(NATIVE_CC_CMD)

.ml.cmo:
	$(BYTE_CC_CMD)

.mll.ml:
	ocamllex $<

# is 'haxe' really phony?
.PHONY: haxe libs
