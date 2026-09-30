{ config, pkgs, pkgs-unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    pkgs.alt-tab-macos      # windows like alt-tab
    pkgs.docker             # docker
    pkgs.k9s                # kubernetes cluster manager   
    pkgs.karabiner-elements # key remapping software
    pkgs.kubernetes-helm    # package manager for kubernetes
    pkgs.monitorcontrol     # for adjusting brightness of external monitors
    pkgs.opentofu           # open source fork of terraform
    pkgs.stats              # show various mac-os stats
    pkgs.terraform          # tool for building, changing, and versioning infrastructure
    pkgs.uv                 # python package manager
    pkgs.vault              # tool for managing secrets
  ] ++ [
    pkgs-unstable.jetbrains.rider   # c# ide
    pkgs-unstable.jetbrains.pycharm # python ide
  ];
}
