{
  user,
  ...
}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = user.git;
      init.defaultBranch = "master";
      core.editor = "vim";
      core.autocrlf = "input";
      push.autoSetupRemote = true;
      gpg.format = "ssh";
      commit.gpgsign = true;
      # the flake repo in /etc/nix-darwin is owned by one user but shared with all users
      safe.directory = [
        "/etc/nix-darwin"
        "/private/etc/nix-darwin"
      ];

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
        contents.user = {
          name = "jblik";
          email = "jblik@noreply.codeberg.org";
          signingKey = "${user.ssh."codeberg.org".IdentityFile}.pub";
        };
        condition = "hasconfig:remote.*.url:ssh://git@codeberg.org/**";
      }
    ]
    ++ import ./${user.profile}/git-include-if.nix user;

    ignores = [
      ".DS_Store"
      ".direnv/"
      ".envrc"
      ".idea/"
    ];
  };
}
