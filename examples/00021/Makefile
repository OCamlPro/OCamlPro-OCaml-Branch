OFLAGS=-inline 100 -dsel -dspill -dsplit
OCAMLOPT=../local/bin/ocamlopt

all:
	echo "module Code1 = struct" > code_more.ml
	cat code1.ml >> code_more.ml
	echo "end" >> code_more.ml
	echo '(*' >> code_more.ml
	echo '-drawlambda' >> code_more.ml
	$(OCAMLOPT) $(OFLAGS) -drawlambda -c code1.ml 2>> code_more.ml
	echo '-dlambda' >> code_more.ml
	$(OCAMLOPT) $(OFLAGS) -dlambda -c code1.ml 2>> code_more.ml
	echo '-dclosure' >> code_more.ml
	$(OCAMLOPT) $(OFLAGS) -dclosure -c code1.ml 2>> code_more.ml
	echo >> code_more.ml
	echo '-dcmm' >> code_more.ml
	$(OCAMLOPT) $(OFLAGS) -dcmm -S -c code1.ml 2>> code_more.ml
	echo '-S' >> code_more.ml
	cat code1.s >> code_more.ml
	echo '*)' >> code_more.ml
	echo "module Code2 = struct" >> code_more.ml
	cat code2.ml >> code_more.ml
	echo "end" >> code_more.ml
	echo '(*' >> code_more.ml
	echo '-drawlambda' >> code_more.ml
	$(OCAMLOPT) $(OFLAGS) -drawlambda -c code2.ml 2>> code_more.ml
	echo '-dlambda' >> code_more.ml
	$(OCAMLOPT) $(OFLAGS) -dlambda -c code2.ml 2>> code_more.ml
	echo '-dclosure' >> code_more.ml
	$(OCAMLOPT) $(OFLAGS) -dclosure -c code2.ml 2>> code_more.ml
	echo >> code_more.ml
	echo '-dcmm' >> code_more.ml
	$(OCAMLOPT) $(OFLAGS) -dcmm -S -c code2.ml 2>> code_more.ml
	echo '-S' >> code_more.ml
	cat code2.s >> code_more.ml
	echo '*)' >> code_more.ml

