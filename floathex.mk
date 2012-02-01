OCAMLOPT=ocamlopt

floathex: floathex.ml
	$(OCAMLOPT) -o floathex $^

clean:
	rm -f floathex *.cm? *.o
