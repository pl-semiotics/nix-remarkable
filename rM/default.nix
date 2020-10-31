# if release is not set, import packages from subdirectories if they exist
{ srcs, hostPkgs }: with srcs;

(import nixpkgs {
  system = "x86_64-linux";
  config.allowUnsupportedSystem = true;
  crossSystem = import ./system.nix { lib = import <nixpkgs/lib>; };
  overlays = [
    # Basic tools---the toolchain packages
    (import ./toolchain.nix)
    # Upref to host packages, for symmetry's sake
    (self: super: { inherit hostPkgs; })
  ];
  crossOverlays = [
    # Basic rM packages---chiefly the Linux kernel and headers. These
    # need to go here in order to prevent the build toolchain being
    # built with glibc built against the rM kernel headers.
    (import ./cross-overlay.nix)
    # Try to link most things statically, to reduce the number/net
    # size of files that must be deployed
    (import ./static.nix)
    (import <nixpkgs/pkgs/top-level/static.nix>)
    # Overrides to make more things work (hopefully)
    # Most of this should probably be moved into crossOverlays
    (import ./overrides.nix)
    # Local packages
    (import ./packages.nix srcs)
  ];
}).__splicedPackages
