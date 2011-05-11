OCAMLC=../byterun/ocamlrun ../ocamlc -I ../stdlib
#FUNCTOR=-functor X
#PACK_FUNCTOR=-pack-functor Make

all:
	$(OCAMLC) -c x.mli
	$(OCAMLC) -c $(FUNCTOR) a.mli
	$(OCAMLC) -c $(FUNCTOR) a.ml
	$(OCAMLC) -c $(FUNCTOR) b.ml
	$(OCAMLC) -c $(FUNCTOR) lib.ml
	$(OCAMLC) -c $(PACK_FUNCTOR) -o lib.cmo a.cmo b.cmo
	$(OCAMLC) -c test.ml
	$(OCAMLC) -o test.byte lib.cmo test.cmo

PACKER=	../../../../ocplib-private/src/ocamlpack/ocamlpack.byte

# ocamlpack can pack modules into a file as a functor. Use it to generate lib.ml
# that will be used for testing
pack: $(PACKER) x.mli a.mli a.ml b.ml
	$(PACKER) -o lib.ml -pack-functor Make -functor x.mli a.ml b.ml
	$(OCAMLC) -c lib.ml
	$(OCAMLC) -c test.ml
	$(OCAMLC) -o test.byte lib.cmo test.cmo

clean:
	rm -f *.cm? *~ *.o *.byte
