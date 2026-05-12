{
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
    (import ./git.nix {
      inherit user;
      lib = pkgs.lib;
    })
    ./karabiner.nix
    (import ./p10k.nix { inherit user; })
    ./sublime.nix
    (import ./zsh.nix {
      inherit pkgs user;
      lib = pkgs.lib;
    })
  ];
}
