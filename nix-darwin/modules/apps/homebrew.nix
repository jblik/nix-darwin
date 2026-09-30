{ config, pkgs, lib, ... }:

{
  # Darwin-level Homebrew configuration
  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation.cleanup = "uninstall";

    brews = [
      # these need to be removed, this is to keep my current mac working
      "openssl@3"
      "node"
      "angular-cli"
      "antigen"
      "docker-compose"
      "dotnet@8"
      "duti"
      "libusb"
      "git-lfs"
      "harfbuzz"
      "handbrake"
      "helm"
      "mas" # for mac app store.
      "mkvtoolnix"
      "nmap"
      "nvm"
      "openjdk@17"
      "pandoc"
      "pipx"
      "protobuf-c"
      "postgis"
      "postgresql@16"
      "ripgrep"
      "sbt"
      "tag"
      "telnet"
      "tmux"
      "bufbuild/buf/buf"
      "cxreiff/tap/ttysvr"
      "hashicorp/tap/consul"
      "hashicorp/tap/nomad"
      "mongodb/brew/mongodb-community@7.0"
      "timescale/tap/timescaledb"
    ];
    casks = [
        "sublime-text"
    ];
    # mac app store:
    # mas search "<app name>"
    masApps = {
#      "1Password for Safari" = 1569813296;
#      "pairvpn" = 1347012179;
#      "tailscale" = 1475387142;
#      "Windows App" = 1295203466;
#      "wireguard" = 1451685025;
#      "wipr" = 1320666476;
    };
  };
}
