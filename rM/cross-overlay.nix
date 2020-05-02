self: super: {
  linux_remarkable = self.callPackage ./linux-remarkable/kernel.nix {
    kernelPatches = [];
  };
  linuxPackages_remarkable = self.linuxPackagesFor self.linux_remarkable;
  linuxPackages = self.linuxPackages_remarkable;
  linux = self.linuxPackages.kernel;
  linuxHeaders = self.callPackage ./linux-remarkable/headers.nix {};
}
