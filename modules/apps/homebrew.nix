{
  config,
  lib,
  pkgs,
  updateHomebrew,
  user,
  ...
}:
{
  config = {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        extraFlags = [ "--force" "--verbose" ];
      }
      // lib.optionalAttrs updateHomebrew {
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
        "docker-desktop"
        "karabiner-elements"
        "ghostty"
        "jagex"
        "sublime-text"
        "homerow"
      ];
      masApps = {
        "Tailscale" = 1475387142;
        "uBlock Origin Lite" = 6745342698;
        "Xcode" = 497799835;
      };
    };

    system.activationScripts.postActivation.text = lib.mkIf updateHomebrew ''
      echo "Upgrading Mac App Store apps (mas upgrade)..."
      sudo -u ${user.username} ${lib.getExe pkgs.mas} upgrade
    '';
  };
}
