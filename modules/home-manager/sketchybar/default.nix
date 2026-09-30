{ pkgs, lib, ... }:
let
  theme = import ./theme.nix;
  sbar = lib.getExe pkgs.sketchybar;

  topAnchoredItems = [
    ./items/bar.nix
    ./items/apple.nix
    ./items/clock.nix
    ./items/front-app-menus.nix
  ];

  centerAnchoredItems = [ ./items/spaces.nix ];

  bottomAnchoredItemsTopToBottom = [
    ./items/ram.nix
    ./items/gpu.nix
    ./items/cpu.nix
    ./items/network.nix
    ./items/battery.nix
  ];

  bottomAnchoredItemsInAddOrder = lib.reverseList bottomAnchoredItemsTopToBottom;

  itemFiles = topAnchoredItems ++ centerAnchoredItems ++ bottomAnchoredItemsInAddOrder;

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
