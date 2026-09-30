{ config, pkgs, lib, ... }:

{
  # Darwin-level Homebrew configuration
  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation.cleanup = "uninstall";

    brews = [
      # these need to be removed, this is to keep my current mac working
      "node"
      "angular-cli"
      "antigen"
      "docker-compose"
#      "duti"
      "git-lfs"
      "nmap"
      "nvm"
      "ripgrep"
      "sbt"
      "telnet"
#      "hashicorp/tap/nomad"
      "mongodb/brew/mongodb-community@7.0"
      "timescale/tap/timescaledb"
    ];
    casks = [
        "sublime-text"
    ];
    # mac app store:
    # mas search "<app name>"
    masApps = {
       "Vimlike" = 1584519802;
       "uBlock Origin Lite" = 6745342698;
       "Tailscale" = 1475387142;
#       "Windows App" = 1295203466;
    };
  };
}
