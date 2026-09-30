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
      imports = [{}
        ./common
      ];
    };
in
{
  ${users.personal.username} = mkUser "personal";
  ${users.work.username} = mkUser "work";
}
