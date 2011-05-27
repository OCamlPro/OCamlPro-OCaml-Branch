all:
	ocamlc -c a/x.ml
	ocamlc -c -I a/ a/c.ml
	ocamlc -c a/a/x.ml
	ocamlc -c -I a/a a/a/y.ml
	ocamlc -pack -o a/a/a.cmo a/a/x.cmo a/a/y.cmo
	ocamlc -pack -o a/b.cmo a/a/a.cmo
	ocamlc -pack -o a.cmo a/x.cmo a/b.cmo a/c.cmo
	ocamlc -o test.byte a.cmo

clean:
	rm -f test.byte *.cm? */*.cm? */*/*.cm?

