{ pkgs, pkgs-unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # find more at https://search.nixos.org/packages
  environment.systemPackages =
    with pkgs;
    [
      pkgs.alt-tab-macos # windows like alt-tab
      pkgs.ansible # configuration management tool
      pkgs.docker # docker
      pkgs.duti # tool to set default apps
      pkgs.inetutils # gnu network utils
      pkgs.k9s # kubernetes cluster manager
#      pkgs.karabiner-elements # key remapping software
      pkgs.kubernetes-helm # package manager for kubernetes
      pkgs.meslo-lgs-nf # font for powerlevel10k
      pkgs.monitorcontrol # for adjusting brightness of external monitors
      pkgs.nmap # network discovery tool
      pkgs.openssh # ssh tool
      pkgs.opentofu # open source fork of terraform
      pkgs.ripgrep # faster grep
      pkgs.stats # show various mac-os stats
      pkgs.tailscale # vpn
      pkgs.terraform # tool for building, changing, and versioning infrastructure
      pkgs.uv # python package manager
      pkgs.vault # tool for managing secrets
      pkgs.zsh-powerlevel10k # zsh theme
    ]
    ++ [
      pkgs-unstable.jetbrains.idea # intellij
      pkgs-unstable.jetbrains.rider # c# ide
      pkgs-unstable.jetbrains.pycharm # python ide
      pkgs-unstable.jetbrains.datagrip # database viewer
    ];
}
