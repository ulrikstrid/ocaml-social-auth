(lang dune 2.8)

(name social-auth)

(version 0.1.0)

(generate_opam_files true)

(source
 (github ulrikstrid/ocaml-social-auth))

(license BSD3)

(authors "Ulrik Strid")

(maintainers "ulrik.strid@outlook.com")

(package
 (name social-auth)
 (synopsis "Social Authentication for OCaml")
 (description
  "Implementations for different social providers, building ontop of oauth2 and OIDC")
 (depends
  uri
  lwt
  oidc
  (dream :dev)
  ; TODO: These should be optional since the client should be generic
  cohttp
  cohttp-lwt-unix))
