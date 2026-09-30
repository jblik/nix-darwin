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
      revset-aliases = {
        "immutable_heads()" = ''builtin_immutable_heads() | remote_bookmarks(glob:"release/*", remote=exact:"origin")'';
      };
    }
    // import ./${user.profile}/jj-settings.nix user;
  };
}
