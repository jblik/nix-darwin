{ ... }:

{
  # todo: https://seansantry.com/development/2022/12/14/split-git-nix/
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "jblik";
        email = "88430125+jblik@users.noreply.github.com";
      };
      init.defaultBranch = "master";
      core.editor = "vim";
      core.autocrlf = "input";
      push.autoSetupRemote = true;

      alias = {
        lg = "log --oneline --graph --decorate";
        wip = ''!git add . && git commit -m "wip" && git push'';
        ac = "!git add . && git commit -m";
        acp = ''!f() { git add . && git commit -m "$1" && git push; }; f'';
        cb = ''!git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done'';
      };
    };

    # todo make gitconfigs with home manager
    # can use the ~/.config/git/domain.gitconfig or something
    includes = [
      {
        condition = "gitdir:~/school_local";
        # could do something like this: condition = "hasconfig:remote.*.url:git@school.git.com:*/**";
        path = "~/school_local/.gitconfig";
      }
      {
        condition = "gitdir:~/Projects/";
        path = "~/Projects/.gitconfig";
      }
    ];

    ignores = [
      ".DS_Store"
      ".idea/"
    ];
  };
}
