{
  lib,
  pkgs,
  user,
  ...
}:
{
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
  home.username = user.username;
  home.homeDirectory = pkgs.lib.mkForce user.homeDirectory;
  imports = [
    ./git.nix
    ./karabiner.nix
    ./p10k.nix
    ./sublime.nix
    ./zsh.nix
  ];
}
