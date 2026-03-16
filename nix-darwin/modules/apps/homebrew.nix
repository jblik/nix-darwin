{ config, pkgs, lib, ... }:

{
  # options = {
  #   homebrew-update.enable = lib.mkEnableOption "enable homebrew updating";
  # };
  # config = lib.mkIf config.homebrew-update.enable {
  #   homebrew.onActivation = {
  #       autoUpdate = true;
  #       upgrade = true;
  #   };
  # };
  
  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation = {
        cleanup = "uninstall";
    };

    brews = [
        "node"
        "nmap"                                # Network scanner for discovering hosts, open ports, and services.
        "ripgrep"                             # Very fast recursive text search tool, commonly used as a better grep.
        "sbt"                                 # Scala Build Tool for building and managing Scala projects.
        "telnet"                              # Classic command-line Telnet client, mostly used for simple network connectivity testing now.
#        "hashicorp/tap/nomad"
        "mongodb/brew/mongodb-community@7.0"  # MongoDB Community Server version 7.0.
        "timescale/tap/timescaledb"           # TimescaleDB extension for PostgreSQL optimized for time-series workloads.
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
}
