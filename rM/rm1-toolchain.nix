{ stdenv, fetchurl, libarchive, python3, which, file }:

# We use this instead of the upstream remarkable-toolchain because the
# latter uses the wrong python3

stdenv.mkDerivation rec {
  pname = "rm1-toolchain-bin-${version}";
  version = "3.1.2";
  src = fetchurl {
    url = "https://storage.googleapis.com/remarkable-codex-toolchain/codex-x86_64-cortexa9hf-neon-rm10x-toolchain-${version}.sh";
    sha256 = "1p77cwpw99yarnc2wssjf14abyiszvh2fg69qjm0k9kn9i8q7hx1";
    executable = true;
  };
  nativeBuildInputs = [ libarchive python3 which file ];
  phases = [ "patchPhase" "installPhase" ];
  installPhase = ''
    mkdir -p $out
    ENVCLEANED=1 $src -y -d $out
  '';
}
