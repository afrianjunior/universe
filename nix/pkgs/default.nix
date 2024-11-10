{ pkgs ? import <nixpkgs> {}
, ...
}:
let
  inherit (pkgs) callPackage;
in {
  mongodb-bin_7 = callPackage ./mongodb.nix {
    version = "7.0.14";
    hash = "sha256-tM+MquEIeFE17Mi4atjtbfXW77hLm5WlDsui/CRs4IQ=";
  };
}
