{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rm-video-player";
  version = "unstable-2020-10-17";

  src = fetchFromGitHub {
    owner = "LinusCDE";
    repo = pname;
    rev = "9cb4708f93c8db6277193329ed29626b0fe0ef70";
    sha256 = "0pzm095mrw1rllikyf3xm163znvs7gzi4wcklsasabsijmhli1pk";
  };

  # the repo specifies the linker to use, which we delete
  patchPhase = ''
    rm .cargo/config
  '';

  cargoSha256 = "122rpi142h13bjfbq80ikswfbxcqm4mz8yrgbx732hsp0rw6bc3h";

  meta = with stdenv.lib; {
    description = " PoC of playing some kind of video for some time on the reMarkable ";
    homepage = "https://github.com/LinusCDE/rm-video-player";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
