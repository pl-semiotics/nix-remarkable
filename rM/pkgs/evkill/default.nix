{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "evkill";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Enteee";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yr8rxghb32q3p2wr928c91ygb42mcaijf87jxwa24id8fshlbdr";
  };

  cargoSha256 = "17m8f48a3737zm55m4k8a5jwwbk8y2nkn8cdw4fg5lfs88mjagcq";

  meta = with stdenv.lib; {
    description = "A silencer for evdev";
    homepage = "https://github.com/Enteee/evkill";
    license = licenses.asl20;
    maintainers = with maintainers; [ siraben ];
  };
}
