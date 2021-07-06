{ rmVersion, lib }:
# This uses a custom config to match the path used in the existing
# tools, and then overrides everything deriveid from config (mostly
# parsed) to be identical to that which would be elaborated from the
# config "armv7l-unknown-linux-gnueabihf";

let
  parameters = if rmVersion == 1 then {
    config = "arm-oe-linux-gnueabi";
    name = "zero-gravitas";
    arch = "armv7-a";
    fpu = "neon";
    cpu = "cortex-a9";
  } else if rmVersion == 2 then {
    config = "arm-remarkable-linux-gnueabi";
    name = "zero-sugar";
    arch = "armv7ve";
    fpu = "neon"; # Could perhaps be neon-vfpv4? This is following upstream
    cpu = "cortex-a7";
  } else throw "Unknown rmVersion!";
in with parameters;

{
  parsed = {
    cpu = lib.systems.parse.cpuTypes.armv7l;
    vendor = { name = "unknown"; };
    kernel = lib.systems.parse.kernels.linux;
    abi = lib.systems.parse.abis.gnueabihf;
  };
  inherit config;  # doesn't really match oh well
  system = "arm-linux";
  libc = "glibc";
  inherit name;
  inherit rmVersion;
  gcc = {
    # The default toolchain environment setup puts -mfloat-abi=hard
    # in $CC, which is somewhat important---anything that uses the
    # standard library from this toolchain _must_ be compiled
    # hardfp. If we put this here, it'll get included in the wrapper
    # flags, which is basically the same thing.
    #
    # However, the Linux kernel doesn't use the standard library and
    # requires the ability to be built softfp, so we can't just set
    # =hard. Therefore, we actually mess with add-flags.sh in the
    # compiler derivation to set -mfloat-abi based on an environment
    # variable (defaulting to hard), and override that variable in
    # the kernel.
    #
    # It would be nice to make modules also automatically have that
    # variable set, but that appears to not be possible.

    # Unfortunately, on the remarkable2, there is a similar problem
    # with the march/mcpu/mfpu family. It seems that the march,
    # mspu, mfpu values that we use match those used by the upstream
    # (oecore) setup script. However, we set these in the cc
    # wrapper, while the oecore script sets them via e.g.
    # CC="/path/to/cc -flags". Flags set by the latter approach
    # appear to be stripped by the kernel (and KCFLAGS is set with
    # just the sysroot option to deal with this). Hence, we need
    # some way to allow removing all of these flags during kernel
    # builds. So, instead of letting the cc wrapper set them up the
    # way it normally would (via nix-support/cc-cflags-before), we
    # do something quite nasty and patch nix-support/add-flags.sh to
    # add them only based on NIX_CFLAGS_* environment variables.
    optional = {
      inherit arch cpu fpu;
      float-abi = "hard";
    };
  };
  linux-kernel = {
    inherit name;
    baseConfig = "${name}_defconfig";
    target = "zImage"; # unclear whether this is right. check device?
    autoModules = false;
    DTB = true;
  };
}
