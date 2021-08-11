let
  pkgs = import ./nix/sources.nix { };
  inherit (pkgs) lib;
  socialAuthPkgs = pkgs.recurseIntoAttrs (import ./nix { inherit pkgs; }).native;
  socialAuthDrvs = lib.filterAttrs (_: value: lib.isDerivation value) socialAuthPkgs;

  filterDrvs = inputs:
    lib.filter
      (drv:
        # we wanna filter our own packages so we don't build them when entering
        # the shell. They always have `pname`
        !(lib.hasAttr "pname" drv) ||
        drv.pname == null ||
        !(lib.any (name: name == drv.pname || name == drv.name) (lib.attrNames socialAuthDrvs)))
      inputs;
in
with pkgs;

(mkShell {
  inputsFrom = lib.attrValues socialAuthDrvs;
  buildInputs = with ocamlPackages; [ merlin ocamlformat_0_18_0 utop ocaml-lsp redemon reenv ];
}).overrideAttrs (o: {
  propagatedBuildInputs = filterDrvs o.propagatedBuildInputs;
  buildInputs = filterDrvs o.buildInputs;
})
