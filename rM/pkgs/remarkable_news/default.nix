{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "remarkable_news";
  version = "unstable-2020-09-28";

  goPackagePath = "github.com/Evidlo/remarkable_news";

  src = fetchFromGitHub {
    owner = "Evidlo";
    repo = pname;
    rev = "b74b6ad40a0b7a376dece5fd91100546796a3b2c";
    sha256 = "000id1xg6k6riv89h92fzkxg59rym2i60bh6v02hpdm5ql0wrs6a";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Show daily news/comics on your reMarkable's suspend screen";
    homepage = "https://github.com/Evidlo/remarkable_news";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.siraben ];
    platforms = platforms.unix;
  };
}
