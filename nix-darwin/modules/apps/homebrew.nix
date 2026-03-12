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
        #      "duti"                               # Utility for setting default macOS app handlers for file types and URL schemes from the command line.
        "git-lfs"                             # Git Large File Storage extension for versioning large binary files outside normal Git blobs.
        "nmap"                                # Network scanner for discovering hosts, open ports, and services.
        "ripgrep"                             # Very fast recursive text search tool, commonly used as a better grep.
        "sbt"                                 # Scala Build Tool for building and managing Scala projects.
        "telnet"                              # Classic command-line Telnet client, mostly used for simple network connectivity testing now.
        #      "hashicorp/tap/nomad"
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
        "Tailscale" = 1475387142;
        "uBlock Origin Lite" = 6745342698;
        "Vimlike" = 1584519802;
        #       "Windows App" = 1295203466;
    };
};
}
