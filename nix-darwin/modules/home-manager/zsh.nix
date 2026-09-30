{ pkgs, lib, ... }:

{
    programs.zsh = {
        enable  = true;
        autosuggestion.enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
          theme = "powerlevel10k/powerlevel10k";
        };
    
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
    
        initContent = lib.mkBefore ''
          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
          
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';
    };
}