{ machine, ... }:
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
    } // (if machine.headless then {
      os.copyToClipboardCmd = "printf {{text}} | pbcopy";
    } else { });
  };
}
