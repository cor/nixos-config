{ isDarwin, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "06A6337C2BDD1365883C0668DB347466107E589F";
    };
  };

} // (if isDarwin then { } else {
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSshSupport = true;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
})
