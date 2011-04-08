all: test1 test2

test:
	for i in [0-9][0-9]-*; do (cd $$i; make test); done

# Generates correct data files from old version of the compiler
test1:
	for i in [0-9][0-9]-*; do (cd $$i; make test1); done

# Test new version of the compiler and compare generated data files
test2:
	for i in [0-9][0-9]-*; do (cd $$i; make test2); done

clean:
	for i in [0-9][0-9]-*; do (cd $$i; make clean); done
