self: super: {
  libvncserver = super.libvncserver.overrideAttrs (oA: {
    # Remove a bunch of stupid dependencies
    buildInputs = [ ];
    cmakeFlags = (oA.cmakeFlags or []) ++ [ "-DWITH_PNG=OFF" ];
    #buildInputs = oA.propagatedBuildInputs;
  });
}
