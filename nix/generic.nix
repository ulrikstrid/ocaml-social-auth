{ pkgs, stdenv, lib, ocamlPackages, static ? false, doCheck }:

with ocamlPackages;

let
  oidcSources = builtins.fetchTarball
    https://github.com/ulrikstrid/ocaml-oidc/archive/47d00b5614820736413d1ba40fc078f5046fd648.tar.gz;
in

rec {
  oidcPackages = import ("${oidcSources}/nix/generic.nix")
    {
      pkgs = pkgs;
      stdenv = stdenv;
      lib = lib;
      ocamlPackages = ocamlPackages;
      static = static;
      doCheck = doCheck;
    };

  example = buildDunePackage {
    pname = "example";
    version = "0.0.1-dev";

    src = lib.filterGitSource {
      src = ./..;
      dirs = [ "example" ];
      files = [ "dune-project" "social-auth.opam" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      uri
      lwt
      oidcPackages.oauth
      dream
      cohttp
      cohttp-lwt-unix
    ];

    inherit doCheck;

    meta = {
      description = "Examples";
      license = stdenv.lib.licenses.bsd3;
    };
  };
}







