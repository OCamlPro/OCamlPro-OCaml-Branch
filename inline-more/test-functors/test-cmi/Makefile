ROOT=../..

OCAMLC=$(ROOT)/byterun/ocamlrun $(ROOT)/ocamlc -I $(ROOT)/stdlib
# -dinstr
OCAMLOPT=$(ROOT)/byterun/ocamlrun $(ROOT)/ocamlopt -I $(ROOT)/stdlib -dcmm -dclosure -S

all: byte

byte:
	$(OCAMLC) -c a.mli
	$(OCAMLC) -c b.mli
	$(OCAMLC) -pack -o x.cmi a.cmi b.cmi

clean:
	rm -f *~ *.cm?


