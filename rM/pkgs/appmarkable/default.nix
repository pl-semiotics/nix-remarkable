{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "appmarkable";
  version = "unstable-2020-10-17";

  src = fetchFromGitHub {
    owner = "LinusCDE";
    repo = pname;
    rev = "b3b68dbe8faf4d5faed9d87dd127034885bc5289";
    sha256 = "116q3gbvj741vdxmjj16pny4xkhxgqywhmyi98y03mppw6bgpzhb";
  };

  # the repo specifies the linker to use, which we delete
  patchPhase = ''
    rm .cargo/config
  '';

  cargoSha256 = "0c1qc6lk91qnzqkdsg45ghd73g67xkr4liakp69apxkls18nz9ln";

  meta = with stdenv.lib; {
    description = "Turn your program into a very simple app for draft similar";
    homepage = "https://github.com/LinusCDE/appmarkable";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
