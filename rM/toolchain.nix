self: super: {
  rmToolchain = self.callPackage ./toolchain-pkgs.nix { };

  libcCrossChooser = name:
    builtins.trace name (if name == "glibc" &&
                            self.targetPlatform ? rmVersion
                         then self.targetPackages.rmToolchain.libc or
                           self.rmToolchain.libraries
                         else super.libcCrossChooser name);

  gcc = if self.targetPlatform ? rmVersion
    then self.rmToolchain.gcc else super.gcc;
}
