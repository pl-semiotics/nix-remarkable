{ fetchFromGitHub, }:

{
  version = "4.9.84-zero-gravitas";
  src = fetchFromGitHub {
    owner = "reMarkable";
    repo = "linux";
    rev = "1774e2a6a091fdc081324e966d3db0aa9df75c0b";
    sha256 = "0pjk6ag2s685ar6d31sx484k1wyhyn7g7mz9zib910zcmfb3rdqf";
  };
}
