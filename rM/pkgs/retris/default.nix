{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "retris";
  version = "0.5.8-1";

  src = fetchFromGitHub {
    owner = "LinusCDE";
    repo = pname;
    rev = version;
    sha256 = "09cccw8my1mjzmazlfsz6bh0clajgnqpwy01jbl1hslc53a34ijx";
  };

  # the repo specifies the linker to use, which we delete
  patchPhase = ''
    rm .cargo/config
  '';

  cargoSha256 = "0nbl88npm200ks47zah04pb4lnkfil4ivmhwkbh0y3qvvfpikw31";

  meta = with stdenv.lib; {
    description = "Implementation of rust tetris_core on the reMarkable using libremarkable";
    homepage = "https://github.com/LinusCDE/retris";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
