{
  pkgs,
  lib,
  user,
  ...
}:

let
  flakePath = "~/nix-darwin";
  flakeRef = "${flakePath}#${user.profile}";
  flakeUpdateRef = "${flakeRef}-updatehomebrew";
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    #    oh-my-zsh = {
    #      enable = true;
    #      plugins = [ "git" ];
    #    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    shellAliases = {
      nix-rebuild = "sudo darwin-rebuild switch --flake ${flakeRef}";
    };

    siteFunctions = {
      nix-update = ''
        sudo -v
        nix flake update --flake ${flakePath} || return 1

        if ! git -C ${flakePath} diff --quiet -- ${flakePath}/flake.lock; then
          git -C ${flakePath} add ${flakePath}/flake.lock || return 1
          git -C ${flakePath} commit -m "update flake.lock" || return 1
        fi

        sudo darwin-rebuild switch --flake ${flakeUpdateRef}
      '';
      nix-update-gc = ''
        local days="''${1:-10}"
        nix-update
        nix-gc "''${days}"
      '';
      nix-gc = ''
        local days="''${1:-10}"
        echo "Removing generations older than ''${days}d..."
        nix-collect-garbage --delete-older-than "''${days}d"
        echo "Optimizing Nix store..."
        nix-store --optimise
      '';
    };

    initContent = lib.mkBefore ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # this loads in the .p10k.zsh configuration from this repo, 
      # maybe think about just configuring it when you set up a new machine
      [[ ! -f ~/.config/p10k/.p10k.zsh ]] || source ~/.config/p10k/.p10k.zsh
    '';
  };
}
