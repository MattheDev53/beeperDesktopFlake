{ pkgs, appimageTools, copyDesktopItems, makeDesktopItem, ... }:
let
pname = "beeper";
version = "4.2.166";
src = pkgs.fetchurl {
  url = "https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop";
  hash = "sha256-HCfZxu/pVsDV5ezdMqNqOB9pP09yG20S/dKavMLWsnI=";
};

appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  pkgs = pkgs;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItem = ( makeDesktopItem {
    name = "beeper";
    desktopName = "Beeper";
    exec = "${pname} %u";
    icon = "beepertexts.png";
    type = "Application";
    terminal = false;
    comment= "The ultimate messaging app";
    categories = [ "Network" "Chat" ];
    mimeTypes =[ "x-scheme-handler/beeper" ];
  });

  extraInstallCommands = ''
  mkdir -p $out/share/applications
  cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
  cp -r ${appimageContents}/usr/share/icons $out/share

  # unless linked, the binary is placed in $out/bin/cursor-someVersion
  # ln -s $out/bin/${pname}-${version} $out/bin/${pname}
        '';
}
