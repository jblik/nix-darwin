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
        extraFlags = [ "--force" ];
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
      #      todo broken
      # mas search "<app name>"
      masApps = {
        "Tailscale" = 1475387142;
        "uBlock Origin Lite" = 6745342698;
        "Xcode" = 497799835;
      };
    };

    system.activationScripts.postActivation.text = lib.mkIf updateHomebrew ''
      echo >&2 "Upgrading Mac App Store apps (mas upgrade)..."
      PATH="${config.homebrew.prefix}/bin:${lib.makeBinPath [ pkgs.mas ]}:$PATH" \
        mas upgrade || echo >&2 "warning: mas upgrade failed (continuing)"
    '';
  };
}
