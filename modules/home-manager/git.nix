{
  user,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = user.git;
      init.defaultBranch = "master";
      core.editor = "vim";
      core.autocrlf = "input";
      push.autoSetupRemote = true;
      gpg.format = "ssh";

      alias = {
        lg = "log --oneline --graph --decorate";
        wip = ''!git add . && git commit -m "wip" && git push'';
        c = "git commit -m";
        ac = "!git add . && git commit -m";
        acp = ''!f() { git add . && git commit -m "$1" && git push; }; f'';
        cb = ''!git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done'';
      };
    };

    includes = [
      {
        contents = {
          user = {
            name = "jblik";
            email = "88430125+jblik@users.noreply.github.com";
          };
        };
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
      }
      {
        contents = {
          user = {
            name = "jblik";
            email = "jblik@noreply.codeberg.org";
          };
          commit.gpgsign = true; # todo: can setup everywhere and then put global
          user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBu+qV9Gu9qUejqLlY4iuUWfP4aN9juK2qg9Wrobb/Tq";
        };
        condition = "hasconfig:remote.*.url:ssh://git@codeberg.org/**";
      }
    ]
    ++ import ./${user.profile}/gitIncludeIf.nix;

    ignores = [
      ".DS_Store"
      ".idea/"
    ];
  };
}
