{ inputs, pkgs-unstable, theme, machine, ... }:
{
  programs.yazi = {
    enable = true;
    package = if machine.darwin then pkgs-unstable.yazi else inputs.yazi.packages.${pkgs-unstable.system}.default;
    enableZshIntegration = true;

    settings = {
      log = {
        enabled = false;
      };
      manager = {
        ratio = [ 2 8 0 ];
        show_hidden = true;
        sort_dir_first = true;
      };
    };
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

