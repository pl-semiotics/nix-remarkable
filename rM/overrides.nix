self: super:

{
  libvncserver = (super.libvncserver.overrideAttrs (oA: {
    # Remove unnecessary dependencies
    buildInputs = [ ];
    cmakeFlags = [ "-DWITH_PNG=OFF" ];
  }));
}
