{
  config,
  lib,
  pkgs,
  updateHomebrew,
  ...
}:
{
  config = {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        extraFlags = [
          "--force"
          "--verbose"
        ];
      }
      // lib.optionalAttrs updateHomebrew {
        autoUpdate = true;
        upgrade = true;
      };
      brews = [
        "michaeldhopkins/tap/jjpr"
      ];
      taps = [ ];
      casks = [
        "docker-desktop"
        "karabiner-elements"
        "ghostty"
        "jagex"
        "sublime-text"
        "homerow"
        "wifiman"
      ];
      masApps = {
        "Actions" = 1586435171;
        "Tailscale" = 1475387142;
        "uBlock Origin Lite" = 6745342698;
        "Xcode" = 497799835;
      };
    };

    system.activationScripts.postActivation.text = lib.mkIf updateHomebrew ''
      echo "Upgrading Mac App Store apps (mas upgrade)..."
      sudo -u ${config.system.primaryUser} ${lib.getExe pkgs.mas} upgrade
    '';
  };
}
