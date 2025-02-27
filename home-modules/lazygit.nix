{ ... }:
{
  programs.lazygit = {
    enable = true;
    # package = pkgs-unstable.lazygit;
    settings = {
      gui.showBottomLine = false;
      git.autoFetch = false;
      # git.paging = {
      #   colorArg = "always";
      #   pager = "delta --dark --paging=never";
      # };
      os.copyToClipboardCmd = "printf {{text}} | pbcopy";
    };
  };
}
