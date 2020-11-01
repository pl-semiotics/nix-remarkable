{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "remarkable-fractals";
  version = "unstable-2018-05-01";

  src = fetchFromGitHub {
    owner = "dannyow";
    repo = pname;
    rev = "7931882c15dc16c68736d0261999ee7cadbb4322";
    sha256 = "16maf5381k8kq2w7zsnz9n3vsqpnwghvc9b7z5kx8kgc7q2a6q8f";
  };

  cargoSha256 = "19i64zs6l2l8x0hsz69cb8fpq7icrlfz4n1z2xqa963gbf00cppr";

  meta = with stdenv.lib; {
    description = "Draw fractals on the reMarkable tablet";
    homepage = "https://github.com/dannyow/reMarkable-fractals";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
