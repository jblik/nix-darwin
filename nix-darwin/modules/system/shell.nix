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

  environment.shellAliases = {
    nix-update = "nix flake update --flake ${flakePath} && sudo darwin-rebuild switch --flake ${flakeRef}";
    nix-update-gc = "nix flake update --flake ${flakePath} && sudo darwin-rebuild switch --flake ${flakeRef} && nix-collect-garbage --delete-older-than 30d && nix-store --optimise";
    nix-rebuild = "sudo darwin-rebuild switch --flake ${flakeRef}";
    nix-gc = "nix-collect-garbage --delete-older-than 30d && nix-store --optimise";
  };
}