{ pkgs, lib, ... }:

{
    programs.git = {
        enable = true;
    
        settings = {
          userName = "jblik";
          userEmail = "88430125+jblik@users.noreply.github.com";

          init.defaultBranch = "master";
          core.editor = "vim";
          core.autocrlf = "input";
          push.autoSetupRemote = true;

          aliases = {
            lg  = "log --oneline --graph --decorate";
            wip = ''"!git add . && git commit -m "wip" && git push"'';
            ac  = "!git add . && git commit -m";
            acp = ''"!f() { git add . && git commit -m \"$1\" && git push; }; f"'';
            cb  = ''"!git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == \"[gone]\" {sub(\"refs/heads/\", \"\", $1); print $1}'); do git branch -D $branch; done"'';
          };
        };
    
        ignores = [
          ".DS_Store"
          ".idea/"
        ];
    };
}