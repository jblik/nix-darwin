{ config, lib, username, ... }:

let
  repoPath = "/Users/${username}/configuration";
  flakePath = "/Users/${username}/configuration/nix-darwin";
  flakeRef = "${flakePath}#${username}";
  flakeUpdateRef = "${flakePath}#${username}-updatehomebrew";
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
        
        if ! git diff -C ${repoPath} --quiet -- ${flakePath}/flake.lock; then
          git add ${flakePath}flake.lock || return 1
          git commit -C ${repoPath} -m "update flake.lock" || return 1
        fi
        
        sudo darwin-rebuild switch --flake ${flakeUpdateRef}
    }
    nix-update-gc() {
        nix flake update --flake ${flakePath} || return 1
        
        if ! git diff -C ${repoPath} --quiet -- ${flakePath}/flake.lock; then
          git add ${flakePath}flake.lock || return 1
          git commit -C ${repoPath} -m "update flake.lock" || return 1
        fi
        
        sudo darwin-rebuild switch --flake ${flakeUpdateRef} || return 1
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