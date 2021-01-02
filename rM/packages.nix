srcs: self: super:

{
  linuxPackages_remarkable = super.linuxPackages_remarkable.extend
    (selflp: superlp: {
      mxc_epdc_fb_damage = selflp.callPackage srcs.mxc_epdc_fb_damage.drv {};
    });
  libqsgepaper-snoop = self.callPackage srcs.libqsgepaper-snoop.drv {};
  rM-input-devices = self.callPackage srcs.rM-input-devices.drv {};
  rM-vnc-server = self.callPackage srcs.rM-vnc-server.drv {};
}
