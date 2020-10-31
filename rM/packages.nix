srcs: self: super:

{
  linuxPackages_remarkable = super.linuxPackages_remarkable.extend
    (selflp: superlp: {
      mxc_epdc_fb_damage = selflp.callPackage srcs.mxc_epdc_fb_damage.drv {};
    });
  rM-vnc-server = self.callPackage srcs.rM-vnc-server.drv {};
  remarkable-news = self.callPackage ./remarkable_news {};
}
