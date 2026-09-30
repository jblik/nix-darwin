{ users, ... }:
let
  mkUser =
    profile:
    { pkgs, lib, ... }:
    {
      programs.home-manager.enable = true;
      home.stateVersion = "25.11";
      home.username = users.${profile}.username;
      home.homeDirectory = lib.mkForce users.${profile}.homeDirectory;
      imports = [
        ./git.nix
        ./karabiner.nix
        ./p10k.nix
        ./sublime.nix
        ./zsh.nix
        ./${profile}
      ];
    };
in
{
  ${users.personal.username} = mkUser "personal";
  ${users.work.username} = mkUser "work";
}
