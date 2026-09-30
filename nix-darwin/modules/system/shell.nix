{ config, lib, username, ... }:

let
  flakePath = "/Users/${username}/configuration/nix-darwin";
  flakeRef = "${flakePath}#${username}";
in
{
  users.users.${username} = {
    shell = "/bin/zsh";
  };
  
  environment.variables = {
    EDITOR = "vim";
  };

  environment.shellAliases = {
    # todo if there were changes to the flake.lock, commit then
    nix-update = ''nix flake update --flake ${flakePath} && sudo darwin-rebuild switch --flake ${flakeRef}'';
    nix-update-gc = ''nix flake update --flake ${flakePath} && sudo darwin-rebuild switch --flake ${flakeRef} && nix-gc'';
    nix-rebuild = "sudo darwin-rebuild switch --flake ${flakeRef}";
  };
  
  programs.zsh.interactiveShellInit = ''
    nix-gc() {
      local days="''${1:-10}"
      echo "Removing generations older than ''${days}d..."
      nix-collect-garbage --delete-older-than "''${days}d"
      echo "Optimizing Nix store..."
      nix-store --optimise
    }
'';
}