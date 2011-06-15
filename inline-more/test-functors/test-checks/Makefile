ROOT=../..

good: good.ocamlc good.ocamlopt
bad: bad.ocamlc bad.ocamlopt

good.ocamlc:
	$(MAKE) -f Makefile.ocamlc good

good.ocamlopt:
	$(MAKE) -f Makefile.ocamlopt good

bad.ocamlc:
	$(MAKE) -f Makefile.ocamlc bad

bad.ocamlopt:
	$(MAKE) -f Makefile.ocamlopt bad


clean:
	rm -f *~
	$(MAKE) -f Makefile.ocamlc clean
	$(MAKE) -f Makefile.ocamlopt clean
