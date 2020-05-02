{ stdenv, fetchurl, libarchive, python, which, file }:

stdenv.mkDerivation {
  pname = "rm-toolchain-bin";
  version = "1.8-23.9.2019";
  src = import <nix/fetchurl.nix> {
    url = "https://remarkable.engineering/oecore-x86_64-cortexa9hf-neon-toolchain-zero-gravitas-1.8-23.9.2019.sh";
    sha256 = "cbd5ffa0e2ee4b244d5780289d3950f6228d8e3372f90c0dd728b45201ca61e6";
    executable = true;
  };
  nativeBuildInputs = [ libarchive python which file ];
  phases = [ "patchPhase" "installPhase" ];
#  patchPhase = ''
#    patchShebangs $src
#  '';
  installPhase = ''
    mkdir -p $out
    ENVCLEANED=1 $src -y -d $out
  '';
}
