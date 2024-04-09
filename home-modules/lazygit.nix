{ pkgs-unstable, ... }:
{
  programs.lazygit = {
    enable = true;
    package = pkgs-unstable.lazygit;
    settings = {
      gui.showBottomLine = false;
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };
}
