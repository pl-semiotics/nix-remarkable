
{ fetchFromGitHub, }:

{
  src = fetchFromGitHub {
    owner = "reMarkable";
    repo = "linux";
    # lars/zero-gravitas_4.9
    rev = "94e64aded1cfe344c0fe96448a89cfd687ce6b66";
    # rev = "1774e2a6a091fdc081324e966d3db0aa9df75c0b";
    sha256 = "1cwjcka02v81kwhy3jdmmdq6biw43r3wp8498c7gkmc3j94sm8sq";
  };
  version = "4.9.84-zero-gravitas";
}
