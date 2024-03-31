{ inputs, pkgs-unstable, theme, isDarwin, ... }:
{
  programs.yazi = {
    enable = true;
    package = if isDarwin then pkgs-unstable.yazi else inputs.yazi.packages.${pkgs-unstable.system}.default;
    enableZshIntegration = true;
    keymap = {
      manager.prepend_keymap = [{
        on = [ "l" ];
        run = "plugin --sync smart-enter";
        desc = "Enter the child directory, or open the file";
      }];
    };
  };

  xdg.configFile."yazi/plugins".source = ./yazi/plugins;
}

