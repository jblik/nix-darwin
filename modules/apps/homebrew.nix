{ config, lib, ... }:

{
  options = {
    updateHomebrew.enable = lib.mkEnableOption "enable Homebrew auto-update and upgrade during activation";
  };

  config = {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
      }
      // lib.optionalAttrs config.updateHomebrew.enable {
        autoUpdate = true;
        upgrade = true;
      };
      brews = [ ];
      taps = [ 
        "Arthur-Ficial/tap"
      ];
      casks = [
      "apfel"
      "docker-desktop"
        "karabiner-elements"
        "ghostty"
        "monitorcontrol"
        "stats"
        "sublime-text"
      ];
      # mas search "<app name>"
      masApps = {
        #"Tailscale" = 1475387142;
        #"uBlock Origin Lite" = 6745342698;
        #"Vimlike" = 1584519802;
        #       "Windows App" = 1295203466;
      };
    };
  };
}
