{
  enable = true;
  pinentryFlavor = "gnome3";
  enableSshSupport = true;

  # cache the keys forever so we don't get asked for a password
  defaultCacheTtl = 31536000;
  maxCacheTtl = 31536000;
}