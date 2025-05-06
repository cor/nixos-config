{ ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      color = "080808";
      show-failed-attempts = true;
    };
  };
}
