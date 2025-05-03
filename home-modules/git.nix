{ pkgs, lib, machine, user, ... }:
{
  programs.git =
    let
      sshSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN0JRbnTsz4eEUeL6My/ew+rX3Qojawn+Y1B3buPuyC";
    in
    {
      enable = true;
      userName = user.githubName;
      userEmail = user.email;
      delta.enable = true;
      lfs.enable = true;
      extraConfig = {
        color.ui = true;
        github.user = user.githubName;
        gpg.format = "ssh";
        init.defaultBranch = "main";
        core.excludesFile = toString (pkgs.writeText "global-gitignore" ''
          .aider*
          .DS_Store
        '');

        # Fix go private dependency fetching by using SSH instead of HTTPS
        "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";
        commit.gpgsign = true;
      } // (if machine.darwin then {
        user.signingkey = sshSigningKey;
        gpg."ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        gpg.format = "ssh";
      } else if machine.headless then {
        user.signingkey = sshSigningKey;
        signing = {
          signByDefault = true;
          key = sshSigningKey;
        };
      } else {
        user.signingkey = sshSigningKey;
        gpg."ssh".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        gpg.format = "ssh";
      });
    };
}
