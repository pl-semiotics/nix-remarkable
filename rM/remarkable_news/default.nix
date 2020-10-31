{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule {
  name = "remarkable-news";
  goPackagePath = "https://github.com/Evidlo/remarkable_news";

  vendorSha256 = "1879j77k96684wi554rkjxydrj8g3hpp0kvxz03sd8dmwr3lh83j";

  src = fetchFromGitHub {
    owner = "Evidlo";
    repo = "remarkable_news";
    rev = "b74b6ad40a0b7a376dece5fd91100546796a3b2c";
    sha256 = "000id1xg6k6riv89h92fzkxg59rym2i60bh6v02hpdm5ql0wrs6a";
  };
}
