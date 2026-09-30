{
  users,
  ...
}:
let
  mkUser =
    user:
    { pkgs, lib, ... }:
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
  ${users.personal.username} = mkUser users.personal;
  ${users.work.username} = mkUser users.work;
}
