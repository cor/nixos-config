{ pkgs, inputs, machine, lib, ... }:
let
  accent = "A670DBFF"; # "rgb(166, 112, 219)";
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${lib.getExe inputs.ghostty.packages.${machine.system}.ghostty} -e";
        inner-pad = 16;
        vertical-pad = 16;
        horizontal-pad = 16;
        dpi-aware = "yes";
      };
      # colors = {
      #   background = "24283BFF";
      #   text = "C0CAF5FF";
      #   match = "FF9E64FF";
      #   placeholder = "9ECE6AFF";
      #   selection = accent;
      #   selection-text = "1A1B26FF";
      #   selection-match = "1A1B26FF";
      #   border = accent;
      # };

      border = {
        width = 6;
        radius = 20;
      };
    };
  };
}
