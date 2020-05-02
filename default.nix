# if release is not set, import packages from subdirectories if they exist
{ release ? false
, nixpkgs ? <nixpkgs>
, srcs ? import ./srcs.nix release nixpkgs
}:

rec {
  rmPkgs = import ./rM { inherit srcs hostPkgs; };
  hostPkgs = import ./host { inherit srcs rmPkgs; };
}
