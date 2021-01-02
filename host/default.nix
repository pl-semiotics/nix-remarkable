{ srcs, rmPkgs, rm1Pkgs, rm2Pkgs }: with srcs;

import nixpkgs {
  system = "x86_64-linux";
  overlays = [
    (self: super: { inherit rmPkgs rm1Pkgs rm2Pkgs; })
    (import ./packages.nix srcs)
  ];
}
