
{ fetchFromGitHub, }:

{
  src = fetchFromGitHub {
    owner = "reMarkable";
    repo = "linux";
    rev = "lars/zero-gravitas_4.9";
    hash = "sha256-WKOqSZKD1fkOQ4mgy0cehMdlcKu1yeEhnwFtAdRkkrM=";
  };
  version = "4.9.84-zero-gravitas";
}
