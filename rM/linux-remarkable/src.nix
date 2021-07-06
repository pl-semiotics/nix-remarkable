
{ fetchFromGitHub, targetPlatform }:
let
 parameters =
   if targetPlatform.rmVersion == 1 then {
     rev = "1774e2a6a091fdc081324e966d3db0aa9df75c0b";
     sha256 = "0pjk6ag2s685ar6d31sx484k1wyhyn7g7mz9zib910zcmfb3rdqf";
     version = "4.9.84-zero-gravitas";
   } else if targetPlatform.rmVersion == 2 then {
     rev = "d4e7e07a390f8b2544ca09d69142d18114149004";
     sha256 = "1k1xkgsw2j9cspg2lpwvvbhd9m8mdcn9akqrrzpnfabbm5nbycfr";
     version = "4.14.78";
   } else throw "Unknown rmVersion";
in with parameters; {
  src = fetchFromGitHub {
    owner = "reMarkable";
    repo = "linux";
    inherit rev sha256;
  };
  inherit version;
}
