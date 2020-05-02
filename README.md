This repository consolidates Nix tooling for developing for the
[reMarkable tablet](https://remarkable.com).

Currently, it includes both a nixpkgs cross configuration for the
reMarkable, and Nix expressions for various tools, currently
including:
- [mxc_epdc_fb_damage](https://github.com/peter-sa/mxc_epdc_fb_damage)
- [rM-vnc-server](https://github.com/peter-sa/rM-vnc-server)
- [gst-libvncclient-rfbsrc](https://github.com/peter-sa/gst-libvncclient-rfbsrc)

To build a local copy of the above packages, create a `pkgs/`
directory, clone the relevant repository into it, and run `nix build`
in the resulting subdirectory.

To build release copies of any of the projects, run `nix build --arg
release true -f . <attribute path>` from this repo (without needing to
manually download anything else), where `<attribute path>` is one of:
- `rmPkgs.linuxPackages.mxc_epdc_fb_damage`
- `rmPkgs.rM-vnc-server`
- `hostPkgs.gst-libvncclient-rfbsrc`

To develop your own packages for the reMarkable, use the `rmPkgs`
attribute of the set computed in [default.nix](./default.nix) as a
`nixpkgs` appropriately configured for cross-compilation (e.g. its
`stdenv.mkDerivation` will generate derivations that cross-build for
the reMarkable).
