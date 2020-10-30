{ callPackage, wrapBintoolsWith, wrapCCWith, runCommand, hostPkgs }:

rec {
  rm-toolchain = hostPkgs.remarkable-toolchain;
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
    ln -s ${rm-toolchain}/sysroots/x86_64-oesdk-linux/usr/bin/arm-oe-linux-gnueabi $out/bin
    mkdir -p $out/nix-support
  '';
  libraries = runCommand "rm-toolchain-libs" {
    propagatedBuildInputs = [ rm-toolchain ];
  } ''
    mkdir -p $out
    ln -s ${rm-toolchain}/sysroots/cortexa9hf-neon-oe-linux-gnueabi/usr/include $out/
    cp -rsHf ${rm-toolchain}/sysroots/cortexa9hf-neon-oe-linux-gnueabi/lib $out
    chmod -R u+w $out/lib
    cp -rsHf ${rm-toolchain}/sysroots/cortexa9hf-neon-oe-linux-gnueabi/usr/lib $out
  '';

  binutils = wrapBintoolsWith {
    bintools = binaries;
    libc = libraries;
    extraBuildCommands = ''
      # copied from the default wrapper script since there's no way to
      # set this :-(
      echo "/lib/ld-linux-armhf.so.3" >$out/nix-support/dynamic-linker
      echo "-dynamic-linker /lib/ld-linux-armhf.so.3" > $out/nix-support/libc-ldflags-before

      # maybe hacky to use sysroot here?
      echo "--sysroot=${rm-toolchain}/sysroots/cortexa9hf-neon-oe-linux-gnueabi" >>$out/nix-support/libc-ldflags-before

      # definitely hacky but whatever
      sed -i "1 a\\
      NIX_ENFORCE_PURITY=0\\
      NIX_DONT_SET_RPATH_''${suffixSalt}=1
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
      echo "--sysroot=${rm-toolchain}/sysroots/cortexa9hf-neon-oe-linux-gnueabi" >>$out/nix-support/cc-cflags-before

      # Work around float abi problems (see note in system.nix)
      # Extract suffixSalt since there's no other way to get it in here
      # (alternatively: use overrideAttrs on the produced derivation)
      # If the final line of cc-wrapper ever changes, this breaks :-(
      suffixSalt="$(tail -n 1 $out/nix-support/add-flags.sh | sed 's/export NIX_CC_WRAPPER_FLAGS_SET_\(.*\)=1/\1/')"
      echo "doing $suffixSalt"
      echo "mangleVarList \"NIX_CFLAGS_COMPILE_FLOAT_ABI\" \''${role_suffixes[@]+\"\''${role_suffixes[@]}\"}" >>$out/nix-support/add-flags.sh
      echo "NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}=\"\''${NIX_CFLAGS_COMPILE_FLOAT_ABI_''${suffixSalt}:--mfloat-abi=hard} \$NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}\"" >>$out/nix-support/add-flags.sh
    '';
  };
}
