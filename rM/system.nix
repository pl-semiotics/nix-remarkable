{ lib }:
# This uses a custom config to match the path used in the existing
# tools, and then overrides everything deriveid from config (mostly
# parsed) to be identical to that which would be elaborated from the
# config "armv7l-unknown-linux-gnueabihf";
{
  parsed = {
    cpu = lib.systems.parse.cpuTypes.armv7l;
    vendor = { name = "unknown"; };
    kernel = lib.systems.parse.kernels.linux;
    abi = lib.systems.parse.abis.gnueabihf;
  };
  config = "arm-oe-linux-gnueabi"; # doesn't really match oh well
  system = "arm-linux";
  libc = "glibc";
  platform = {
    name = "zero-gravitas";
    gcc = {
      arch = "armv7-a";
      # The default toolchain environment setup puts -mflaot-abi=hard
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
      # It would be nice to make modules also automatically have that variable set, but that appears to not be possible.
      #float-abi = "hard";
      fpu = "neon";
      cpu = "cortex-a9";
    };
    kernelArch = "arm";
    kernelMajor = "4.1";
    kernelBaseConfig = "zero-gravitas_defconfig";
    kernelTarget = "zImage"; # unclear whether this is right. check device?
    kernelDTB = true;
    kernelAutoModules = false;
  };
}
