{
  enable = true;
  terminal = "xterm-256color";
  secureSocket = false;
  clock24 = true;
  escapeTime = 0;
  historyLimit = 1000000;
  baseIndex = 1;
  extraConfig = ''
    set -g mouse on
  '';
}