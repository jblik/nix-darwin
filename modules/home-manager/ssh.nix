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
        AppleUseKeychain = "yes";
      };
      # todo: move to profile
    }
    // user.ssh;
  };
}
