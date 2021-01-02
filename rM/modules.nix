self: super: {
  linux_remarkable = super.linux_remarkable.override (o: {
    linuxManualConfig = a: o.linuxManualConfig (a // {
      configfile = self.runCommandNoCC "extra-modules-config" {} ''
        cp ${a.configfile} $out
        chmod +w $out
        echo "CONFIG_INPUT_MISC=y" >>$out
        echo "CONFIG_INPUT_UINPUT=m" >>$out
      '';
    });
  });
}
