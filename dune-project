(lang dune 3.8)

(cram enable)

(name test-http-ocaml)

(license MIT)

(maintainers "David Sancho <dsnxmoreno@gmail.com>")

(authors "David Sancho <dsnxmoreno@gmail.com>")

(source
 (github davesnx/test-http-ocaml))

(generate_opam_files true)

(implicit_transitive_deps false)

(package
 (allow_empty true)
 (name test-http-ocaml)
 (synopsis "test-http-ocaml ???")
 (description "test-http-ocaml ???")
 (depends
  ocaml
  ocamlformat
  ocaml-lsp-server
  lwt
  lwt_ppx
  http
  mem_usage
  uri
  h2
  httpaf
  eio
  eio_main
  cohttp-eio
))
