release: _nixpkgs:

let
  bootPkgs = import _nixpkgs {};

  nixpkgs = if release then bootPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "fce7562cf46727fdaf801b232116bc9ce0512049";
    sha256 = "14rvi69ji61x3z88vbn17rg5vxrnw2wbnanxb7y0qzyqrj7spapx";
  } else _nixpkgs;
in with import <nixpkgs> {}; let
  upstreamOrLocal = name: ghArgs:
    let path = ./pkgs + ("/" + name) + /derivation.nix; in
    if !release && builtins.pathExists path
    then { drv = path; }
    else let src = fetchFromGitHub ({ repo = name; } // ghArgs); in
         src // { drv = src + "/derivation.nix"; };
in

{
  inherit nixpkgs;

  mxc_epdc_fb_damage = upstreamOrLocal "mxc_epdc_fb_damage" {
    owner = "peter-sa";
    rev = "v0.0.1";
    sha256 = "1pmxy9f9w9skqzshq5da1ab8l83q3l363b0c7k6c877r1jlwf2vv";
  };
  rM-vnc-server = upstreamOrLocal "rM-vnc-server" {
    owner = "peter-sa";
    rev = "v0.0.1";
    sha256 = "0b6ragczvi40l9za468jv79xb0n84nvca8pd3m5w05nfmgsglp33";
  };
  gst-libvncclient-rfbsrc = upstreamOrLocal "gst-libvncclient-rfbsrc" {
    owner = "peter-sa";
    rev = "v0.0.1";
    sha256 = "0ihd6r5qzz3g49yzylfqa730c0l0jri6l1s2k63i1q1l2r339yrz";
  };
}
