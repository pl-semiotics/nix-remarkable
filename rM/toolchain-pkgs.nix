{ callPackage, wrapBintoolsWith, wrapCCWith, runCommand, buildPackages, targetPlatform, lib }: with lib;

let
  rMv = targetPlatform.rmVersion;
  parameters = if rMv == 1 then {
    remarkable-toolchain = buildPackages.remarkable-toolchain;
    hostRoot = "x86_64-oesdk-linux";
    targetRoot = "cortexa9hf-neon-oe-linux-gnueabi";
  } else if rMv == 2 then {
    remarkable-toolchain = callPackage ./rm2-toolchain.nix {};
    hostRoot = "x86_64-codexsdk-linux";
    targetRoot = "cortexa7hf-neon-remarkable-linux-gnueabi";
  } else throw "Unknown rmVersion!";
in with parameters;

rec {
  # Inspired by the android ndk toolchain packaging
  # using runCommand instead of just a path in order to add extra attributes
  binaries = runCommand "rm-toolchain-bins-${remarkable-toolchain.version}" {
    inherit (remarkable-toolchain) version;
    isGNU = true; # based on gcc/binutils
    # need something in lib to appease gdb. this isn't right, but it
    # might not matter
    lib = libraries;
    # This may lead to a missing libcxx, deal with that later
  } ''
    mkdir -p $out
    ln -s ${remarkable-toolchain}/sysroots/${hostRoot}/usr/bin/${targetPlatform.config} $out/bin
    mkdir -p $out/nix-support
  '';
  libraries = runCommand "rm-toolchain-libs-${remarkable-toolchain.version}" {
    inherit (remarkable-toolchain) version;
    propagatedBuildInputs = [ remarkable-toolchain ];
  } ''
    mkdir -p $out
    ln -s ${remarkable-toolchain}/sysroots/${targetRoot}/usr/include $out/
    cp -rsHf ${remarkable-toolchain}/sysroots/${targetRoot}/lib $out
    chmod -R u+w $out/lib
    cp -rsHf ${remarkable-toolchain}/sysroots/${targetRoot}/usr/lib $out
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
      echo "--sysroot=${remarkable-toolchain}/sysroots/${targetRoot}" >>$out/nix-support/libc-ldflags-before

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
      echo "--sysroot=${remarkable-toolchain}/sysroots/${targetRoot}" >>$out/nix-support/cc-cflags-before

      # Work around float abi problems (see note in system.nix)
      # Extract suffixSalt since there's no other way to get it in here
      # (alternatively: use overrideAttrs on the produced derivation)
      # If the final line of cc-wrapper ever changes, this breaks :-(
      #
      # We can't check if the variable is set/unset, because
      # mangleVarList sets the variable unconditionally---so we have
      # to go by empty. Hence, if you would rather just put nothing in
      # for one of these (cough, cough, kernel/module builds), you'd
      # better put some whitespace in there.
      suffixSalt="$(tail -n 1 $out/nix-support/add-flags.sh | sed 's/export NIX_CC_WRAPPER_FLAGS_SET_\(.*\)=1/\1/')"
      echo "doing $suffixSalt"
    '' + optionalString (targetPlatform ? gcc.optional.arch) ''
      echo "mangleVarList \"NIX_CFLAGS_COMPILE_MARCH\" \''${role_suffixes[@]+\"\''${role_suffixes[@]}\"}" >>$out/nix-support/add-flags.sh
      echo "NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}=\"\''${NIX_CFLAGS_COMPILE_MARCH_''${suffixSalt}:--march=${targetPlatform.gcc.optional.arch}} \$NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}\"" >>$out/nix-support/add-flags.sh
    '' + optionalString (targetPlatform ? gcc.optional.cpu) ''
      echo "mangleVarList \"NIX_CFLAGS_COMPILE_MCPU\" \''${role_suffixes[@]+\"\''${role_suffixes[@]}\"}" >>$out/nix-support/add-flags.sh
      echo "NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}=\"\''${NIX_CFLAGS_COMPILE_MCPU_''${suffixSalt}:--mcpu=${targetPlatform.gcc.optional.cpu}} \$NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}\"" >>$out/nix-support/add-flags.sh
    '' + optionalString (targetPlatform ? gcc.optional.fpu) ''
      echo "mangleVarList \"NIX_CFLAGS_COMPILE_MFPU\" \''${role_suffixes[@]+\"\''${role_suffixes[@]}\"}" >>$out/nix-support/add-flags.sh
      echo "NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}=\"\''${NIX_CFLAGS_COMPILE_MFPU_''${suffixSalt}:--mfpu=${targetPlatform.gcc.optional.fpu}} \$NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}\"" >>$out/nix-support/add-flags.sh
    '' + optionalString (targetPlatform ? gcc.optional.float-abi) ''
      echo "mangleVarList \"NIX_CFLAGS_COMPILE_MFLOAT_ABI\" \''${role_suffixes[@]+\"\''${role_suffixes[@]}\"}" >>$out/nix-support/add-flags.sh
      echo "NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}=\"\''${NIX_CFLAGS_COMPILE_MFLOAT_ABI_''${suffixSalt}:--mfloat-abi=${targetPlatform.gcc.optional.float-abi}} \$NIX_CFLAGS_COMPILE_BEFORE_''${suffixSalt}\"" >>$out/nix-support/add-flags.sh
    '';
  };
}
