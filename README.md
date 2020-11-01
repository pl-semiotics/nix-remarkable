# Nix cross-compilation to the reMarkable tablet

## Quick start
Clone and navigate to this repository and run the following to
cross-compile [retris](https://github.com/LinusCDE/retris) to the
reMarkable tablet.  If you want to use the binary cache (recommended),
run `cachix use nix-remarkable` first.

```sh
nix build --arg release true -f . rmPkgs.retris
```

## Description
This repository consolidates Nix tooling for developing for the
[reMarkable tablet](https://remarkable.com).

Currently, it includes both a nixpkgs cross configuration for the
reMarkable, and Nix expressions for various tools, currently
including:
- [chessMarkable](https://github.com/LinusCDE/chessmarkable)
- [gst-libvncclient-rfbsrc](https://github.com/peter-sa/gst-libvncclient-rfbsrc)
- [mxc_epdc_fb_damage](https://github.com/peter-sa/mxc_epdc_fb_damage)
- [plato](https://github.com/LinusCDE/plato)
- [rM-vnc-server](https://github.com/peter-sa/rM-vnc-server)
- [remarkable_news](https://github.com/Evidlo/remarkable_news)
- [retris](https://github.com/LinusCDE/retris)

To build a local copy of the above packages, create a `pkgs/`
directory, clone the relevant repository into it, and run `nix build`
in the resulting subdirectory.

To build release copies of any of the projects, run `nix build --arg
release true -f . <attribute path>` from this repo (without needing to
manually download anything else), where `<attribute path>` is one of:
- `hostPkgs.gst-libvncclient-rfbsrc`
- `rmPkgs.chessmarkable`
- `rmPkgs.linuxPackages.mxc_epdc_fb_damage`
- `rmPkgs.plato`
- `rmPkgs.rM-vnc-server`
- `rmPkgs.remarkable_news`
- `rmPkgs.retris`

To develop your own packages for the reMarkable, use the `rmPkgs`
attribute of the set computed in [default.nix](./default.nix) as a
`nixpkgs` appropriately configured for cross-compilation (e.g. its
`stdenv.mkDerivation` will generate derivations that cross-build for
the reMarkable).
