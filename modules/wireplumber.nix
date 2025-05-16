{
  environment.etc."wireplumber/bluetooth.lua.d/50-bluez-config.lua".text = ''
    bluez_monitor.properties = {
      ["bluez5.enable-hsp"] = false,
      ["bluez5.enable-hfp"] = false,
    }
  '';
}
