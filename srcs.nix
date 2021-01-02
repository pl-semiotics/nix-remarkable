release: _nixpkgs:

let
  bootPkgs = import _nixpkgs {};

  nixpkgs = if release then bootPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "83cbad92d73216bb0d9187c56cce0b91f9121d5a";
    hash = "sha256-QK/qV1AaLnGEu+KwiPX7vSxzU9lMB6zM+kIbvjJo54k=";
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
    owner = "pl-semiotics";
    rev = "8c1692a2dee012a66622aabf59403a1247379ecd";
    sha256 = "0imxw4kwsllgrmnrx9nmws3iqbcp5xkjymkng4r2rsgnyhnkdim8";
  };
  libqsgepaper-snoop = upstreamOrLocal "libqsgepaper-snoop" {
    owner = "pl-semiotics";
    rev = "bea7f852a3a155ee8d05a26ff1311f3e08796608";
    sha256 = "1fm6f1sm0cnkw84zcfdra20f6r7h3mxhhrwwdihalyl6n2gkbqa3";
  };
  rM-input-devices = upstreamOrLocal "rM-input-devices" {
    owner = "pl-semiotics";
    rev = "75de1a96fe9dde15a01872b4d08cef710aa30f80";
    sha256 = "0mqmzqgqa5f5njkqr2k3sc08nfhrx8xp76z9cpxi5xcdhs69c1v2";
  };
  rM-vnc-server = upstreamOrLocal "rM-vnc-server" {
    owner = "pl-semiotics";
    rev = "eebca4c3e0bb7d2f0f9096938ad891c8f4852369";
    sha256 = "1bag4hp6liih7ck6r4ziv0g56xr7siga7ja9q4ds4g9g3vx70mx7";
  };
  gst-libvncclient-rfbsrc = upstreamOrLocal "gst-libvncclient-rfbsrc" {
    owner = "pl-semiotics";
    rev = "v0.0.1";
    sha256 = "0ihd6r5qzz3g49yzylfqa730c0l0jri6l1s2k63i1q1l2r339yrz";
  };
}
