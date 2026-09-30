let
  users = import ../../system/users; # todo: looks shit
  mkUser =
    profile:
    { pkgs, lib, ... }:
    {
      programs.home-manager.enable = true;
      home.stateVersion = "25.11";
      home.username = users.${profile}.username;
      home.homeDirectory = lib.mkForce users.${profile}.homeDirectory;
      imports = [
        # todo: profile based import
        ../../home-manager # todo: looks shit
      ];
    };
in
{
  ${users.personal.username} = mkUser "personal";
  #  ${users.work.username} = mkUser "work";
}
