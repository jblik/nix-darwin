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
    
        # for powerlevel10k
        promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };
}