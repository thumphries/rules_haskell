self: pkgs:
let
  # pkgs = import ../../nixpkgs.nix {};

  libC = pkgs.writeText "LibC.hs" ''
    {-# language NoImplicitPrelude #-}
    module LibC where

    data LibCType = LibCType

    -- | myfunction
    mytype :: LibCType
    mytype = LibCType
  '';

  cabal = pkgs.writeText "libc.cabal" ''
    name: libc
    version: 0.1.0.0
    build-type: simple
    cabal-version: >=1.10

    library
      default-language: Haskell2010
      exposed-modules: LibC
   '';

   src = pkgs.runCommand "libc-src" {} ''
     mkdir $out
     cp ${libC} $out/LibC.hs
     cp ${cabal} $out/libc.cabal
   '';

in
  pkgs.haskell.lib.dontHaddock
    (self.callPackage
      ({ mkDerivation }: mkDerivation {
        pname = "libc";
        version = "0.1.0.0";
        src = src;
        license = pkgs.lib.licenses.mit;
        isExecutable = false;
      }) {})
