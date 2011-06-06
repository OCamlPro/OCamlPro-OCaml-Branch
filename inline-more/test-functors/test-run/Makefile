all: byte opt

byte:
	$(MAKE) -f Makefile.ocamlc all

opt:
	$(MAKE) -f Makefile.ocamlopt all

clean:
	rm -f *~ core
	$(MAKE) -f Makefile.ocamlc clean
	$(MAKE) -f Makefile.ocamlopt clean
	$(MAKE) -f Makefile.ocamlpack clean
