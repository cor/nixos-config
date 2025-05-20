{
  environment.etc."wireplumber/bluetooth.lua.d/50-bluez-config.lua".text =
    # lua
    ''
      bluez_monitor.properties = {
        ["bluez5.enable-hsp"] = false,
        ["bluez5.enable-hfp"] = false,
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = false,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.auto-connect"] = {"audio-sink"},
      }
    '';
}
