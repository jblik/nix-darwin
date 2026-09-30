{ config, lib, ... }:

{
  options = {
    homebrewUpdate.enable = lib.mkEnableOption "enable Homebrew auto-update and upgrade during activation";
  };

  config = {
    homebrew = {
      enable = true;
      taps = builtins.attrNames config.nix-homebrew.taps;
      onActivation = {
        cleanup = "uninstall";
      }
      // lib.optionalAttrs config.homebrewUpdate.enable {
        autoUpdate = true;
        upgrade = true;
      };

      brews = [
        "node"
        "sbt" # Scala Build Tool for building and managing Scala projects.
        # "hashicorp/tap/nomad"
        "mongodb/brew/mongodb-community@7.0" # MongoDB Community Server version 7.0.
      ];
      casks = [
        "ghostty"
        "sublime-text"
      ];
      # mac app store (requires `mas`):
      # mas search "<app name>"
      masApps = {
        # "Tailscale" = 1475387142;
        "uBlock Origin Lite" = 6745342698;
        "Vimlike" = 1584519802;
        #       "Windows App" = 1295203466;
      };
    };
  };
}
