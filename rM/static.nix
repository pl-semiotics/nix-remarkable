self: super: {
  stdenvAdapters = super.stdenvAdapters // {
    # Disable this, since we want to support linking -lc dynamically
    makeStaticBinaries = stdenv: stdenv;
    # Move the change to the correct place in the fixed-point
    propagateBuildInputs = stdenv: stdenv // {
      mkDerivation = args:
        let
          fixup = drv: self.lib.extendDerivation
            true
            { overrideAttrs = f: fixup (drv.overrideAttrs f); }
            (drv.overrideAttrs (args: {
              propagatedBuildInputs = (args.propagatedBuildInputs or []) ++ (args.buildInputs or []);
              buildInputs = [];
            }));
        in fixup (stdenv.mkDerivation args);
    };
  };
}
