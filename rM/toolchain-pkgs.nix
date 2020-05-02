{ callPackage, wrapBintoolsWith, wrapCCWith, runCommand }:

rec {
  oecore-raw = callPackage ./oecore-raw.nix { };
  # Inspired by the android ndk toolchain packaging
  # using runCommand instead of just a path in order to add extra attributes
  binaries = runCommand "rm-toolchain-bins" {
    isGNU = true; # based on gcc/binutils
    # need something in lib to appease gdb. this isn't right, but it
    # might not matter
    lib = libraries;
    # This may lead to a missing libcxx, deal with that later
  } ''
    mkdir -p $out
    ln -s ${oecore-raw}/sysroots/x86_64-oesdk-linux/usr/bin/arm-oe-linux-gnueabi $out/bin
    mkdir -p $out/nix-support
    #echo 'set +u' >$out/nix-support/setup-hook
    #cat ${oecore-raw}/environment-setup-cortexa9hf-neon-oe-linux-gnueabi >>$out/nix-support/setup-hook
  '';
  libraries = runCommand "rm-toolchain-libs" {
    propagatedBuildInputs = [ oecore-raw ];
  } ''
    mkdir -p $out
    ln -s ${oecore-raw}/sysroots/cortexa9hf-neon-oe-linux-gnueabi/usr/include $out/
    cp -rsHf ${oecore-raw}/sysroots/cortexa9hf-neon-oe-linux-gnueabi/lib $out
    chmod -R u+w $out/lib
    cp -rsHf ${oecore-raw}/sysroots/cortexa9hf-neon-oe-linux-gnueabi/usr/lib $out
  '';
  #binutils = binaries // { binutils = binaries; libc = libraries; targetPrefix = "arm-oe-linux-gnueabi"; };
  #gcc = binaries // { cc = binaries; bintools = binutils; libc = libraries; targetPrefix = "arm-oe-linux-gnueabi"; };

  binutils = wrapBintoolsWith {
    bintools = binaries;
    libc = libraries;
    extraBuildCommands = ''
      # copied from the default wrapper script since there's no way to
      # set this :-(
      echo "/lib/ld-linux-armhf.so.3" >$out/nix-support/dynamic-linker
      echo "-dynamic-linker /lib/ld-linux-armhf.so.3" > $out/nix-support/libc-ldflags-before

      # maybe hacky to use sysroot here?
      echo "--sysroot=${oecore-raw}/sysroots/cortexa9hf-neon-oe-linux-gnueabi" >>$out/nix-support/libc-ldflags-before

      # definitely hacky but whatever
      sed -i "1 a\\
      NIX_ENFORCE_PURITY=0\\
      NIX_''${infixSalt}_DONT_SET_RPATH=1
      " $out/bin/*
    '';
  };
  gcc = wrapCCWith {
    cc = binaries;
    bintools = binutils;
    libc = libraries;
    # hack??
    extraBuildCommands = ''
      # maybe hacky to use sysroot here?
      echo "--sysroot=${oecore-raw}/sysroots/cortexa9hf-neon-oe-linux-gnueabi" >>$out/nix-support/cc-cflags-before

      # Work around float abi problems (see note in system.nix)
      # Extract infixSalt since there's no other way to get it in here
      # (alternatively: use overrideAttrs on the produced derivation)
      # If the final line of cc-wrapper ever changes, this breaks :-(
      infixSalt="$(tail -n 1 $out/nix-support/add-flags.sh | sed 's/export NIX_CC_WRAPPER_\(.*\)_FLAGS_SET=1/\1/')"
      echo "doing $infixSalt"
      echo "mangleVarList \"NIX+CFLAGS_COMPILE_FLOAT_ABI\" \''${role_infixes[@]+\"\''${role_infixes[@]}\"}" >>$out/nix-support/add-flags.sh
      echo "NIX_''${infixSalt}_CFLAGS_COMPILE_BEFORE=\"\''${NIX_''${infixSalt}_CFLAGS_COMPILE_FLOAT_ABI:--mfloat-abi=hard} \$NIX_''${infixSalt}_CFLAGS_COMPILE_BEFORE\"" >>$out/nix-support/add-flags.sh
    '';
  };
}
