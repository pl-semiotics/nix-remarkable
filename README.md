This repository consolidates Nix tooling for developing for the
[reMarkable tablet](https://remarkable.com), supporting both versions
1 and 2.

Currently, it includes both a nixpkgs cross configuration for the
reMarkable, and Nix expressions for various tools, currently
including:
- [mxc_epdc_fb_damage](https://github.com/pl-semiotics/mxc_epdc_fb_damage)
- [libqsgepaper-snoop](https://github.com/pl-semiotics/libqsgepaper-snoop)
- [rM-input-devices](https://github.com/pl-semiotics/rM-input-devices)
- [rM-vnc-server](https://github.com/pl-semiotics/rM-vnc-server)
- [gst-libvncclient-rfbsrc](https://github.com/pl-semiotics/gst-libvncclient-rfbsrc)

To build a local copy of the above packages, create a `pkgs/`
directory, clone the relevant repository into it, and run `nix build`
in the resulting subdirectory.

To build release copies of any of the projects, run `nix build --arg
release true -f . <attribute path>` from this repo (without needing to
manually download anything else), where `<attribute path>` is one of:
- `rmPkgs.linuxPackages.mxc_epdc_fb_damage`
- `rmPkgs.libqsgepaper-snoop`
- `rmPkgs.rM-input-devices`
- `rmPkgs.rM-vnc-server`
- `hostPkgs.gst-libvncclient-rfbsrc`

To develop your own packages for the reMarkable, use the `rm1Pkgs` or
`rm2Pkgs` attributes of the set computed in
[default.nix](./default.nix) as a `nixpkgs` appropriately configured
for cross-compilation (e.g. its `stdenv.mkDerivation` will generate
derivations that cross-build for the reMarkable).
