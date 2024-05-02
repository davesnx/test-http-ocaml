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
 (name test-http-ocaml)
 (synopsis "test-http-ocaml ???")
 (allow_empty true)
 (description "test-http-ocaml ???")
 (depends
  (ocaml (> 5.1.0))
  ocamlformat
  ocaml-lsp-server
  riot
  lwt
  lwt_ppx
  http
  mem_usage
  uri
  h2
  httpaf
))
