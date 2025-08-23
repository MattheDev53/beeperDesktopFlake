{ pkgs, appimageTools, ... }:
let
pname = "beeper";
version = "4.1.135";
src = pkgs.fetchurl {
  url = "https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop";
  hash = "sha256-bp0RGU689A8kgphNgJJnlbQBh1fAubwWUvM9StzLwB4=";
};

appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  pkgs = pkgs;
  extraInstallCommands = ''
  install -m 444 -D ${appimageContents}/${pname}texts.desktop -t $out/share/applications
  substituteInPlace $out/share/applications/${pname}texts.desktop \
  --replace 'Exec=AppRun' 'Exec=${pname}'
  cp -r ${appimageContents}/usr/share/icons $out/share

  # unless linked, the binary is placed in $out/bin/cursor-someVersion
  # ln -s $out/bin/${pname}-${version} $out/bin/${pname}
        '';
}
