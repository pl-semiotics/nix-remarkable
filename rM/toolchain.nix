self: super: {
  rmToolchain = self.callPackage ./toolchain-pkgs.nix { };

  libcCrossChooser = name:
    builtins.trace name (if name == "glibc" &&
                            self.targetPlatform.platform.name ==
                              "zero-gravitas"
                         then self.targetPackages.rmToolchain.libc or
                           self.rmToolchain.libraries
                         else super.libcCrossChooser name);

  gcc = if self.targetPlatform.platform.name == "zero-gravitas"
    then self.rmToolchain.gcc else super.gcc;
}
