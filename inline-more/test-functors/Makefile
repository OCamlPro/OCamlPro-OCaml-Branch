OCAMLC=../byterun/ocamlrun ../ocamlc -I ../stdlib
# -dinstr
OCAMLOPT=../byterun/ocamlrun ../ocamlopt -I ../stdlib -dcmm -dclosure
FUNCTOR = -functor arguments/x.mli -dlambda
PACK_FUNCTOR = -pack-functor Make -dlambda

all: byte

byte:
	$(OCAMLC) -c arguments/x.mli
	$(OCAMLC) -c $(FUNCTOR) a.mli
	$(OCAMLC) -c $(FUNCTOR) a.ml
	$(OCAMLC) -c $(FUNCTOR) b.ml
	$(OCAMLC) -I arguments  $(PACK_FUNCTOR) -o lib.cmo a.cmo b.cmo
	$(OCAMLC) -c test.ml
	$(OCAMLC) -o test.byte lib.cmo test.cmo

opt:
	$(OCAMLOPT) -c arguments/x.mli
	$(OCAMLOPT) -c $(FUNCTOR) a.mli
	$(OCAMLOPT) -c $(FUNCTOR) a.ml
	$(OCAMLOPT) -c $(FUNCTOR) b.ml
	$(OCAMLOPT) -I arguments $(PACK_FUNCTOR) -o lib.cmo a.cmo b.cmo
	$(OCAMLOPT) -c test.ml
	$(OCAMLOPT) -o test.byte lib.cmo test.cmo

PACKER=	../../../../ocplib-private/src/ocp-pack/ocp-pack.byte

# ocamlpack can pack modules into a file as a functor. Use it to generate lib.ml
# that will be used for testing
lib.ml: $(PACKER) arguments/x.mli a.mli a.ml b.ml
	$(PACKER) -o lib.ml $(PACK_FUNCTOR) $(FUNCTOR) a.ml b.ml

pack: lib.ml test.ml
	$(OCAMLC) -c lib.ml
	$(OCAMLC) -c test.ml
	$(OCAMLC) -o test.byte lib.cmo test.cmo

clean:
	rm -f *.cm? *~ *.o *.byte
