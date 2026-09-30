{
  user,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = user.git;
    }
    // import ./${user.profile}/jjSettings.nix user;
  };
}
