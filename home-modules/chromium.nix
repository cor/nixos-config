{ pkgs, pkgs-unstable, lib, theme, ... }: 
     let
      package = if theme == "dark" then 
        pkgs-unstable.chromium.override { commandLineArgs = "--force-dark-mode --enable-features=WebUIDarkMode"; } 
      else pkgs-unstable.chromium;

      mkChromiumApp = { name, genericName, url }:  
        pkgs.makeDesktopItem rec {
          inherit name;
          inherit genericName;
          desktopName = name;
          icon = name;
          exec = "${package}/bin/chromium --app=\"${url}\"";
          type = "Application";
          terminal = false;
        };

        createChromiumExtensionFor = browserVersion: { id, sha256, version }:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major package.version);

      in
{
  programs.chromium = {
    enable = true;
    inherit package;
  };

  home.packages = map mkChromiumApp [
    {
      name = "Discord";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      url = "https://discord.com/channels/@me";
    }
    {
      name = "WhatsApp";
      genericName = "Chat app built by Meta";
      url = "https://web.whatsapp.com";
    }
  ];
}
