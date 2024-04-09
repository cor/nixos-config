{ isDarwin, ... }:
{
  programs.git =
    let
      sshSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN0JRbnTsz4eEUeL6My/ew+rX3Qojawn+Y1B3buPuyC";
    in
    {
      enable = true;
      userName = "cor";
      userEmail = "cor@pruijs.dev";
      delta.enable = true;
      lfs.enable = true;
      extraConfig = {
        color.ui = true;
        github.user = "cor";
        gpg.format = "ssh";
        init.defaultBranch = "main";

        # Fix go private dependency fetching by using SSH instead of HTTPS
        "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";
        commit.gpgsign = true;
      } // (if isDarwin then {
        user.signingkey = sshSigningKey;
        gpg."ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        gpg.format = "ssh";
      } else {
        user.signingkey = sshSigningKey;
        signing = {
          signByDefault = true;
          key = sshSigningKey;
        };
      });
    };
}
