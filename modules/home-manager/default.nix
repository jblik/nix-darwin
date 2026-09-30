{ username, homeDirectory, ... }:
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
        ./common
        #         todo: profile based import
        #        "${profile}"
      ];
    };
in
{
  ${users.personal.username} = mkUser "personal";
  # todo: make the work one
  ${users.work.username} = mkUser "work";
}
