{ stdenv, lib, hostPlatform, targetPlatform, buildPackages, linuxManualConfig, callPackage, fetchFromGitHub, lzop, kernelPatches, ... }:

with callPackage ./src.nix {};

(linuxManualConfig {
  inherit stdenv lib src version kernelPatches;
  configfile = "${src}/arch/arm/configs/${targetPlatform.linux-kernel.baseConfig}";
  allowImportFromDerivation = true;
}).overrideAttrs (oA: {
  nativeBuildInputs = (oA.nativeBuildInputs or []) ++ [ lzop ];
  NIX_CFLAGS_COMPILE_MARCH = " ";
  NIX_CFLAGS_COMPILE_MCPU = " ";
  NIX_CFLAGS_COMPILE_MFPU = " ";
  NIX_CFLAGS_COMPILE_MFLOAT_ABI = " ";
})
