{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "chessmarkable";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "LinusCDE";
    repo = pname;
    rev = version;
    sha256 = "02k11klrhaf4bzdnmjbic7dwv4nsjx5r9bl7kb72knify4fd7q94";
  };

  # the repo specifies the linker to use, which we delete
  patchPhase = ''
    rm .cargo/config
  '';

  cargoSha256 = "05g5czsr698d7fwry0n32gixkqikii8dk4kkk87zhgyzzq1pn02c";

  meta = with stdenv.lib; {
    description = "A chess game for the reMarkable tablet";
    homepage = "https://github.com/LinusCDE/chessmarkable";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
