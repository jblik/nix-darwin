{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    pkgs.alt-tab-macos      # windows like alt-tab
    pkgs.docker             # docker!
    pkgs.ghostty-bin        # terminal emulator
    pkgs.jetbrains.rider    # c# ide
    pkgs.jetbrains.pycharm  # python ide
    pkgs.k9s                # kubernetes cluster manager   
    pkgs.karabiner-elements # key remapping software
    pkgs.kubernetes-helm    # package manager for kubernetes
    pkgs.monitorcontrol     # for adjusting brightness of external monitors
    pkgs.opentofu           # open source fork of terraform
    pkgs.stats              # show various mac-os stats
    pkgs.tailscale          # vpn for home server
    pkgs.terraform          # tool for building, changing, and versioning infrastructure
    pkgs.uv                 # python package manager
    pkgs.vault              # tool for managing secrets
  ];
}
