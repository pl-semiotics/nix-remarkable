srcs: self: super:

{
  linuxPackages_remarkable = super.linuxPackages_remarkable.extend
    (selflp: superlp: {
      mxc_epdc_fb_damage = selflp.callPackage srcs.mxc_epdc_fb_damage.drv {};
    });
  appmarkable = self.callPackage ./pkgs/appmarkable {};
  chessmarkable = self.callPackage ./pkgs/chessmarkable {};
  plato = self.callPackage ./pkgs/plato {
    makeRustPlatform = super.pkgs.makeRustPlatform;
    callPackage = super.pkgs.callPackage;
    fetchFromGitHub = super.pkgs.fetchFromGitHub;
  };
  rM-vnc-server = self.callPackage srcs.rM-vnc-server.drv {};
  remarkable_news = self.callPackage ./pkgs/remarkable_news {};
  retris = self.callPackage ./pkgs/retris {};
  rm-video-player = self.callPackage ./pkgs/rm-video-player {};
}
