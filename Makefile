.PHONY: all isail sail install coverage clean docker test core-tests c-tests

all: sail

isail: sail

sail:
	dune build --release

install: sail
	dune install

coverage:
	dune build --release --instrument-with bisect_ppx

clean:
	dune clean

docker:
	docker build --tag sail:0.1 .
	@echo 'for example: docker run --volume `PWD`:/data/ sail:0.1 --help'

install-deps:
	@opam install . --deps-only

check:
	@echo "Running a pre-install check"
	@ocaml -version | grep '4\.[1-9][3-9]' > /dev/null && echo "    Correct OCaml version found" || (echo "OCaml version >4.13 is required" && false)

test:
	SAIL_DIR=`pwd` SAIL=`pwd`/sail test/run_tests.sh

core-tests:
	SAIL_DIR=`pwd` SAIL=`pwd`/sail test/run_core_tests.sh

c-tests:
	SAIL_DIR=`pwd` SAIL=`pwd`/sail test/c/run_tests.py
