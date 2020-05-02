{ srcs, rmPkgs }: with srcs;

import nixpkgs {
  overlays = [
    (self: super: { inherit rmPkgs; })
    (import ./packages.nix srcs)
  ];
}
