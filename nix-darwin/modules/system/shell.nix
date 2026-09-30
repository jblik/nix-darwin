{ config, lib, username, ... }:

let
  flakePath = "/Users/${username}/configuration/nix-darwin";
  flakeRef = "${flakePath}#${username}";
in
{
  programs.zsh.enable = true;

  users.users.${username} = {
    shell = "/bin/zsh";
  };
  
  environment.variables = {
    EDITOR = "vim";
  };
  
  # programs.zsh.enableAutosuggestions = true;

  environment.shellAliases = {
    nix-update = "nix flake update --flake ${flakePath} && sudo darwin-rebuild switch --flake ${flakeRef}";
    nix-update-gc = "nix flake update --flake ${flakePath} && sudo darwin-rebuild switch --flake ${flakeRef} && nix-gc";
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