{ package, lib }: 
     let
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
  enable = true;
  inherit package;

  extensions =
    [
      (createChromiumExtension {
        # ublock origin
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        sha256 = "sha256:0pv1bn42b4i2nnlpw88v8sdpj8y87zh16zic0p4pwh18chh10z5n";
        version = "1.44.4";
      })
      (createChromiumExtension {
        # vimium
        id = "dbepggeogbaibhgnhhndojpepiihcmeb";
        sha256 = "sha256:0sj5najixk40r1hjf9kzq2jns6klfsmipwdj8jl5z76chx9pi3hs";
        version = "1.67.2";
      })
      (createChromiumExtension {
        # 1password
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
        sha256 = "sha256:0ccvpi88s3c1psb5ipkz4cch89ib6h3g9nw8qbxzwvnzh72qg8rl";
        version = "2.5.1";
      })
      (createChromiumExtension {
        # Polkadot
        id = "mopnmbcafieddcagagdcbnhejhlodfdd";
        sha256 = "sha256:1wz50lbi6p182pkr7ysifzyb1inxn5ahvzmi6n5syx87xgrknns5";
        version = "0.44.1";
      })
      (createChromiumExtension {
        # Empty new tab
        id = "dpjamkmjmigaoobjbekmfgabipmfilij";
        sha256 = "sha256:1fv65lfrh1jh9rz3wq26ri4hzkv9n4j563v1arzwys1f8g015fks";
        version = "1.2.0";
      })
      (createChromiumExtension {
        # DF Tube
        id = "mjdepdfccjgcndkmemponafgioodelna";
        sha256 = "sha256:0a4qiq91ypzgnanqj9y4pycij6467f77i1y429rrvka2fkaswf1g";
        version = "1.13.504";
      })
      (createChromiumExtension {
        # Old reddit redirect
        id = "dneaehbmnbhcippjikoajpoabadpodje";
        sha256 = "sha256:194gf0b835nyi5yx4brlywrd6bbd3kal4nn45hxxwml2l0swmncx";
        version = "1.6.1";
      })
      (createChromiumExtension {
        # Less distracting reddit
        id = "ililagkodjpoopfjphagpamfhfbamppa";
        sha256 = "sha256:02prnfphg59nmwzimi74s35k41yzbdiqppgy7xdj6kg92vllms82";
        version = "0.5";
      })
      (createChromiumExtension {
        # LeechBlock
        id = "blaaajhemilngeeffpbfkdjjoefldkok";
        sha256 = "sha256:0m5ar1ymizn61n1cbnhpz9aw2apldavcv4ry775wch8d3p797nsj";
        version = "1.5.2";
      })
   ];
}
