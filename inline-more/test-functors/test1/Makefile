ROOT=../..

OCAMLC=$(ROOT)/byterun/ocamlrun $(ROOT)/ocamlc -I $(ROOT)/stdlib
# -dinstr
OCAMLOPT=$(ROOT)/byterun/ocamlrun $(ROOT)/ocamlopt -I $(ROOT)/stdlib -dcmm -dclosure -S
FUNCTORX = -functor arguments/x.mli -dlambda
PACK_FUNCTORX = -pack-functor Make -dlambda

all: byte

byte: Makefile $(ROOT)/ocamlc
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c -functor arguments/x.mli arguments/y.mli
	$(OCAMLC) -c -functor arguments/y.mli -functor arguments/x.mli a.mli
	$(OCAMLC) -c -functor arguments/y.mli -functor arguments/x.mli a.ml
	$(OCAMLC) -I arguments -functor arguments/x.mli -pack-functor Make -o make_a.cmo a.cmo
	$(OCAMLC) -c -functor arguments/x.mli b.ml
	$(OCAMLC) -I arguments -pack-functor Make -o lib.cmo make_a.cmo b.cmo
	$(OCAMLC) -c test.ml
	$(OCAMLC) -o test.byte lib.cmo test.cmo

opt:
	$(OCAMLOPT) -c arguments/x.mli
	$(OCAMLOPT) -c -for-pack Lib $(FUNCTOR) a.mli
	$(OCAMLOPT) -c -for-pack Lib $(FUNCTOR) a.ml
	$(OCAMLOPT) -c -for-pack Lib $(FUNCTOR) b.ml
	$(OCAMLOPT) -I arguments $(PACK_FUNCTOR) -o lib.cmx a.cmx b.cmx
	$(OCAMLOPT) -c test.ml
	$(OCAMLOPT) -o test.opt lib.cmx test.cmx

PACKER=	../../$(ROOT)/ocplib-private/src/ocp-pack/ocp-pack.byte

# ocamlpack can pack modules into a file as a functor. Use it to generate lib.ml
# that will be used for testing
lib.ml: $(PACKER) arguments/x.mli a.mli a.ml b.ml
	$(PACKER) -o lib.ml $(PACK_FUNCTOR) $(FUNCTOR) a.ml b.ml

good.byte: good1.byte  good2.byte good5.byte good7.byte
bad.byte: bad3.byte  bad4.byte  bad6.byte  bad../8.byte
good1.byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c arguments/y.mli
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/x.cmi a.mli
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/x.cmi a.ml
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/x.cmi b.ml

good2.byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c arguments/y.mli
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/y.cmi a.mli
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/y.cmi a.ml
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/y.cmi b.ml

bad3.byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c arguments/y.mli
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/y.cmi a.mli
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/y.cmi a.ml
	$(OCAMLC) -c -functor arguments/y.cmi -functor arguments/x.cmi b.ml

bad4.byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c arguments/y.mli
	$(OCAMLC) -c -functor arguments/x.cmi a.mli
	$(OCAMLC) -c -functor arguments/x.cmi a.ml
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/y.cmi b.ml

good5.byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c arguments/y.mli
	$(OCAMLC) -c -functor arguments/x.cmi a.mli
	$(OCAMLC) -c -functor arguments/x.cmi a.ml
	$(OCAMLC) -c -functor arguments/y.cmi -functor arguments/x.cmi b.ml

bad6.byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c arguments/y.mli
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/x.cmi a.mli
	$(OCAMLC) -c -functor arguments/x.cmi a.ml
	$(OCAMLC) -c -functor arguments/y.cmi -functor arguments/x.cmi b.ml

good7.byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c -functor arguments/x.mli arguments/y.mli
	$(OCAMLC) -c -functor arguments/y.cmi -functor arguments/x.cmi a.mli

bad8.byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c -functor arguments/x.mli arguments/y.mli
	$(OCAMLC) -c -functor arguments/x.cmi -functor arguments/y.cmi a.mli


pack: lib.ml test.ml
	$(OCAMLC) -c lib.ml
	$(OCAMLC) -c test.ml
	$(OCAMLC) -o test.byte lib.cmo test.cmo

clean:
	rm -f *.cm? *~ *.o *.byte *.opt *.s
