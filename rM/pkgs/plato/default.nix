{ stdenv, callPackage, makeRustPlatform, fetchFromGitHub }:


let mozillaOverlay = fetchFromGitHub {
      owner = "mozilla";
      repo = "nixpkgs-mozilla";
      rev = "8c007b60731c07dd7a052cce508de3bb1ae849b4";
      sha256 = "1zybp62zz0h077zm2zmqs2wcg3whg6jqaah9hcl1gv4x8af4zhs6";
    };
    mozilla = callPackage "${mozillaOverlay.out}/package-set.nix" {};
    rustSpecific = (mozilla.rustChannelOf { date = "2020-10-27"; channel = "nightly"; }).rust;
    rustPlatform = makeRustPlatform {
      cargo = rustSpecific;
      rustc = rustSpecific;
    };
in

rustPlatform.buildRustPackage rec {
  pname = "plato";
  version = "0.9.1-rm-release-4";

  src = fetchFromGitHub {
    owner = "LinusCDE";
    repo = pname;
    rev = version;
    sha256 = "1z8h5nz2zf3agzr1d1pjq7a2l6qqdwjg3bcgwz1y7fwag0yh1pvp";
  };

  # the repo specifies the linker to use, which we delete
  patchPhase = ''
    rm .cargo/config
  '';

  cargoSha256 = "1zk7la8qg1glryk945jqpzc3h3m4z2dpk4cvixfbq7g5dc6mpn57";

  meta = with stdenv.lib; {
    description = "Port of the Plato reader for the reMarkable tablet";
    homepage = "https://github.com/LinusCDE/plato";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
