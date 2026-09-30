{ pkgs }:
let
  rev = "67ad686ea6d4c29ccd54fdaa42cdf35f37a7219c";
in
pkgs.stdenv.mkDerivation {
  pname = "sketchybar-menus";
  version = "0-unstable-2024-05-01";

  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/FelixKratz/dotfiles/${rev}/.config/sketchybar/helpers/menus/menus.c";
    hash = "sha256-2irDrD75TZaQHPvRSPNm0tzsM5yppYazFrv/sTpIPgQ=";
  };

  dontUnpack = true;

  buildInputs = [ pkgs.apple-sdk_15 ];

  buildPhase = ''
    runHook preBuild
    clang -std=c99 -O3 -x c \
      -F/System/Library/PrivateFrameworks/ \
      -framework Carbon -framework SkyLight \
      "$src" -o menus
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp menus $out/bin/menus
    runHook postInstall
  '';

  meta = {
    description = "Front-app menu reader helper for SketchyBar (from FelixKratz/dotfiles)";
    homepage = "https://github.com/FelixKratz/dotfiles";
    license = pkgs.lib.licenses.gpl3Only;
    platforms = pkgs.lib.platforms.darwin;
    mainProgram = "menus";
  };
}
