{
  lib,
  user,
  ...
}:
{
  ${user.username} = {
    _module.args.user = user;
    programs.home-manager.enable = true;
    home.stateVersion = "25.11";
    home.username = user.username;
    home.homeDirectory = lib.mkForce user.homeDirectory;
    home.sessionPath = [
      "${user.homeDirectory}/.local/bin"
      "${user.homeDirectory}/.dotnet/tools" # todo: could build my global tools in nix as well
    ];
    imports = [
      ./${user.profile}/applications.nix
      ./aerospace.nix
      ./ghostty.nix
      ./git.nix
      ./jj.nix
      ./karabiner.nix
      ./p10k.nix
      ./sketchybar
      ./ssh.nix
      ./sublime.nix
      ./zsh.nix
    ];
  };
}
