{
  lib,
  user,
  ...
}:
{
  ${user.username} = {
    programs.home-manager.enable = true;
    home.stateVersion = "25.11";
    home.username = user.username;
    home.homeDirectory = lib.mkForce user.homeDirectory;
    imports = [
      ./aerospace.nix
      ./ghostty.nix
      ./git.nix
      ./karabiner.nix
      ./p10k.nix
      ./rectangle.nix
      ./sketchybar
      ./ssh.nix
      ./sublime.nix
      ./zsh.nix
    ];
  };
}
