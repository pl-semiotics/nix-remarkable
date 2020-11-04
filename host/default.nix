{ srcs, rmPkgs }: with srcs;

import nixpkgs {
  system = "x86_64-linux";
  overlays = [
    (self: super: { inherit rmPkgs; })
    (import ./packages.nix srcs)
  ];
}
