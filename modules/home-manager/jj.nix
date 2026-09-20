{
  user,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = user.git;
      signing = {
        behavior = "own";
        backend = "ssh";
      };
    }
    // import ./${user.profile}/jj-settings.nix user;
  };
}
