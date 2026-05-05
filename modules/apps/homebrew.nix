{
  config,
  lib,
  ...
}:
{
  options = {
    updateHomebrew = lib.mkEnableOption "enable Homebrew auto-update and upgrade during activation";
  };

  config = {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
      }
      // lib.optionalAttrs config.updateHomebrew {
        autoUpdate = true;
        upgrade = true;
      };
      brews = [ "apfel" ];
      taps = [
        "Arthur-Ficial/tap" # for apfel
      ];
      casks = [
        "alt-tab"
        "docker-desktop"
        "karabiner-elements"
        "ghostty"
        "jagex"
        "monitorcontrol"
        "stats"
        "sublime-text"
      ];
      #      todo broken
      # mas search "<app name>"
      masApps = {
        "Tailscale" = 1475387142;
        "uBlock Origin Lite" = 6745342698;
        "Vimlike" = 1584519802;
        #        "Windows App" = 1295203466;
      };
    };
  };
}
