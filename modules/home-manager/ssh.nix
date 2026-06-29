{
  user,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        UseKeychain = "yes";
      };
      # todo: move to profile
    }
    // user.ssh;
  };
}
