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
      "github.com" = {
        User = "git";
        IdentityFile = "${user.homeDirectory}/.ssh/github";
      };
      "gitlab.ost.ch" = {
        User = "git";
        IdentityFile = "${user.homeDirectory}/.ssh/school_gitlab";
      };
      "codeberg.org" = {
        User = "git";
        IdentityFile = "${user.homeDirectory}/.ssh/jblik_forgejo";
      };
    };
  };
}
