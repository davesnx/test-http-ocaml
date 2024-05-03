```
$ opam switch create . 5.1.1 --deps-only -y
$ opam install . --deps-only -y
$ npx serve . # or any other server

# in another terminal can run the different tests
$ opam exec -- dune run ./test_piaf.exe "http://localhost:3000"
$ opam exec -- dune run ./test_cohttp.exe "http://localhost:3000"
$ opam exec -- dune run ./test_blink.exe "http://localhost:3000"
```
