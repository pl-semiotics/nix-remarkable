{ stdenv, hostPlatform, buildPackages, linuxManualConfig, callPackage, fetchFromGitHub, lzop, ... }:

with callPackage ./src.nix {};

(linuxManualConfig {
  inherit stdenv src version;
  configfile = "${src}/arch/arm/configs/zero-gravitas_defconfig";
  allowImportFromDerivation = true;
}).overrideAttrs (oA: {
  nativeBuildInputs = (oA.nativeBuildInputs or []) ++ [ lzop ];
  NIX_CFLAGS_COMPILE_FLOAT_ABI = "-mfloat-abi=soft";
})
