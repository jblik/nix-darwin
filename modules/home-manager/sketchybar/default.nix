{ pkgs, lib, ... }:
let
  theme = import ./theme.nix;
  sbar = lib.getExe pkgs.sketchybar;

  topAnchoredItems = [
    ./items/bar.nix
    ./items/apple.nix
    ./items/battery.nix { position = "left"; }
    ./items/clock.nix
    ./items/front-app-menus.nix
  ];

  centerAnchoredItems = [ ./items/spaces.nix ];

  bottomAnchoredItemsBottomToTop = [
    ./items/battery.nix { position = "right"; }
    ./items/network.nix
#    ./items/cpu.nix
#    ./items/ram.nix
#    ./items/gpu.nix
  ];

  itemFiles = topAnchoredItems ++ centerAnchoredItems ++ bottomAnchoredItemsBottomToTop;

  items = map (
    file:
    import file {
      inherit
        pkgs
        lib
        theme
        sbar
        ;
    }
  ) itemFiles;

  section = item: ''
    ${item.config}
  '';

  configText = lib.concatMapStringsSep "\n" section items;
  initText = lib.concatStringsSep "\n" (lib.filter (s: s != "") (map (item: item.init or "") items));
  extraPackages = lib.concatMap (item: item.packages or [ ]) items;
in
{
  home.packages = [ pkgs.sketchybar-app-font ] ++ extraPackages;

  programs.sketchybar = {
    enable = true;
    configType = "bash";
    extraPackages = [ pkgs.aerospace ];

    config = ''
      ${configText}

      ${initText}

      ${sbar} --update
    '';
  };
}
