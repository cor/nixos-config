{ pkgs, lib, currentSystemName, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      git
      element-desktop
      git-lfs
      file
      gnumake
      killall
      unzip
      niv
      rxvt_unicode
      xclip
      docker-client
      arc-theme
      (writeShellScriptBin "docker-stop-all" ''
        docker stop $(docker ps -q)
        docker system prune -f
      '')
      (writeShellScriptBin "docker-prune-all" ''
        docker-stop-all
        docker rmi -f $(docker images -a -q)    
        docker volume prune -f
      '')
    ] ++ lib.optionals (currentSystemName == "vm-aarch64") [
      # This is needed for the vmware user tools clipboard to work.
      # You can test if you don't need this by deleting this and seeing
      # if the clipboard sill works.
      gtkmm3
    ];

    variables = import ./environment/variables.nix;

    # required for zsh autocomplete
    pathsToLink = [ "/share/zsh" ];
  };
}
