{
  description = "Various programs for the reMarkable tablet";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/ebe09a7ccc634bfad03d21e7a5f25923a451d875;
  inputs.mxc_epdc_fb_damage.url = github:peter-sa/mxc_epdc_fb_damage/v0.0.1;
  inputs.mxc_epdc_fb_damage.flake = false;
  inputs.rM-vnc-server.url = github:peter-sa/rM-vnc-server/v0.0.1;
  inputs.rM-vnc-server.flake = false;
  inputs.gst-libvncclient-rfbsrc.url = github:peter-sa/gst-libvncclient-rfbsrc/v0.0.1;
  inputs.gst-libvncclient-rfbsrc.flake = false;

  outputs = srcs1@{ self, nixpkgs, ... }:
    let
      srcs = builtins.mapAttrs (k: v: v // { drv = v + "/derivation.nix"; }) srcs1;
      rmPkgs = import ./rM { inherit srcs hostPkgs; };
      hostPkgs = import ./host { inherit srcs rmPkgs; };
    in
    {

      # packages.x86_64-linux = { rmPkgs = rmPkgs.recurseIntoAttrs rmPkgs; };
      packages.x86_64-linux = {
        inherit (rmPkgs.linuxPackages) mxc_epdc_fb_damage;
        inherit (rmPkgs) rM-vnc-server chessmarkable retris evkill;
        inherit (rmPkgs) remarkable_news;
        # inherit (rmPkgs) remarkable-fractals;
        inherit (hostPkgs) gst-libvncclient-rfbsrc;
      };

      packages.x86_64-darwin = self.packages.x86_64-linux;

      overlay = final: prev: {
        inherit rmPkgs hostPkgs;
      };

      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    };
}
