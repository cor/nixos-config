{ ... }:
{
  programs.git = {
    enable = true;
    userName = "cor";
    userEmail = "cor@pruijs.dev";
    lfs.enable = true;
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN0JRbnTsz4eEUeL6My/ew+rX3Qojawn+Y1B3buPuyC";
    };
    extraConfig = {
      color.ui = true;
      github.user = "cor";
      gpg.format = "ssh";
      init.defaultBranch = "main";

      # Fix go private dependency fetching by using SSH instead of HTTPS
      "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";
    };
  };
}
