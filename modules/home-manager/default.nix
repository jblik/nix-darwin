{
  user,
  ...
}:
let
  mkUser =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.home-manager.enable = true;
      home.stateVersion = "25.11";
      home.username = user.username;
      home.homeDirectory = lib.mkForce user.homeDirectory;
      imports = [
        ./git.nix
        ./karabiner.nix
        ./p10k.nix
        ./sublime.nix
        ./zsh.nix
      ];
    };
in
{
  ${user.username} = mkUser;
}
