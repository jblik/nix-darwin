{ config, lib, username, ... }:

let
  repoPath = "~/configuration";
  flakePath = "${repoPath}/nix-darwin";
  flakeRef = "${flakePath}#${username}";
  flakeUpdateRef = "${flakeRef}-updatehomebrew";
in
{
  users.users.${username} = {
    shell = "/bin/zsh";
  };
  
  environment.variables = {
    EDITOR = "vim";
  };

  environment.shellAliases = {
    nix-rebuild = "sudo darwin-rebuild switch --flake ${flakeRef}";
  };
  
  programs.zsh.interactiveShellInit = ''
    nix-update() {
        nix flake update --flake ${flakePath} || return 1
        
        if ! git -C ${repoPath} diff --quiet -- ${flakePath}/flake.lock; then
          git -C ${repoPath} add ${flakePath}/flake.lock || return 1
          git -C ${repoPath} commit -m "update flake.lock" || return 1
        fi
        
        sudo darwin-rebuild switch --flake ${flakeUpdateRef}
    }
    nix-update-gc() {
        nix-update
        nix-gc
    }
    nix-gc() {
        local days="''${1:-10}"
        echo "Removing generations older than ''${days}d..."
        nix-collect-garbage --delete-older-than "''${days}d"
        echo "Optimizing Nix store..."
        nix-store --optimise
    }
'';
}