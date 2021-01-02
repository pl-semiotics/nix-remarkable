{ stdenv, fetchurl, libarchive, python3, which, file }:

# We use this instead of the upstream remarkable-toolchain because the
# latter uses the wrong python3

stdenv.mkDerivation rec {
  pname = "rm2-toolchain-bin-${version}";
  version = "2.5.2";
  src = fetchurl {
    url = "https://storage.googleapis.com/codex-public-bucket/codex-x86_64-cortexa7hf-neon-rm11x-toolchain-${version}.sh";
    sha256 = "1p6wxf643rrxylys74qpjgcbg1mnl07q4jw1jph0fclw70dr4hg5";
    executable = true;
  };
  nativeBuildInputs = [ libarchive python3 which file ];
  phases = [ "patchPhase" "installPhase" ];
  installPhase = ''
    mkdir -p $out
    ENVCLEANED=1 $src -y -d $out
  '';
}
