{
  user,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    package = null;
    settings = {
      user = user.git;
    } // import ./${user.profile}/jjSettings.nix user;
  };
}
