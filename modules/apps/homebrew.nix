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
        extraFlags = [ "--force" ];
      }
      // lib.optionalAttrs config.updateHomebrew {
        autoUpdate = true;
        upgrade = true;
      };
      brews = [
        "apfel"
        "gonzo" # k8s log tui
      ];
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
	      "homerow"
      ];
      #      todo broken
      # mas search "<app name>"
      masApps = {
        "Tailscale" = 1475387142;
        "uBlock Origin Lite" = 6745342698;
      };
    };
  };
}
