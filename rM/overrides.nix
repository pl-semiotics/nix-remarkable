self: super: {
  zlib = self.writeText "zlib-in-toolchain" "# zlib.so.1 is in the toolchain";

  libvncserver = super.libvncserver.overrideAttrs (oA: {
    # Remove a bunch of stupid dependencies
    buildInputs = [ ];
    cmakeFlags = (oA.cmakeFlags or []) ++ [
      "-DWITH_PNG=OFF"
      "-DWITH_JPEG=OFF"
      "-DWITH_GNUTLS=OFF"
      "-DWITH_OPENSSL=OFF"
    ];
  });

  unicorn = super.unicorn.overrideAttrs (oA: {
    # Specialize to ARM architecture and build a static library
    cmakeFlags = [ "-DUNICORN_ARCH=arm" "-DUNICORN_BUILD_SHARED=OFF" ];
    # The upstream build system is broken and does not install one of
    # the necessary libraries when building statically
    postInstall = (oA.postInstall or "") + ''
      cp libarm-softmmu.a $out/lib
    '';
  });

  evemu = super.evemu.overrideAttrs (oA: {
    buildInputs = [ self.libevdev ];
    nativeBuildInputs = (oA.nativeBuildInputs or []) ++ [ self.pkgsBuildHost.python ];
  });
}
