{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, configurator, hspec
      , http-client, http-client-tls, json, QuickCheck, stdenv, text
      }:
      mkDerivation {
        pname = "h4h-bot";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          base bytestring configurator http-client http-client-tls json text
        ];
        executableHaskellDepends = [ base ];
        testHaskellDepends = [ base bytestring hspec QuickCheck ];
        description = "Telegram bot for @house4hack";
        license = stdenv.lib.licenses.gpl3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
