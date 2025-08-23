{ pkgs, appimageTools, ... }:
let
pname = "beeper-nightly";
version = "0.90.113";
src = pkgs.fetchurl {
  url = "https://api.beeper.com/desktop/download/linux/x64/beta/com.automattic.beeper.desktop";
  hash = "sha256-XrgUTLV6tHLmdNPDMGi0/UPq0tBlfRHohJYFpSFYBPw=";
};

appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  pkgs = pkgs;
  extraInstallCommands = ''
  install -m 444 -D ${appimageContents}/beeper_nightly.desktop -t $out/share/applications
  substituteInPlace $out/share/applications/beeper_nightly.desktop \
  --replace 'Exec=AppRun' 'Exec=${pname}'
  cp -r ${appimageContents}/usr/share/icons $out/share

  # unless linked, the binary is placed in $out/bin/cursor-someVersion
  # ln -s $out/bin/${pname}-${version} $out/bin/${pname}
        '';
}
