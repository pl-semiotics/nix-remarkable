srcs: self: super:

{
  linuxPackages_remarkable = super.linuxPackages_remarkable.extend
    (selflp: superlp: {
      mxc_epdc_fb_damage = selflp.callPackage srcs.mxc_epdc_fb_damage.drv {};
    });
  rM-vnc-server = self.callPackage srcs.rM-vnc-server.drv {};
  remarkable_news = self.callPackage ./pkgs/remarkable_news {};
  chessmarkable = self.callPackage ./pkgs/chessmarkable {};
}
