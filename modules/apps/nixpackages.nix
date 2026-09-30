{ pkgs, pkgs-unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # find more at https://search.nixos.org/packages
  environment.systemPackages =
    with pkgs;
    [
      pkgs.azure-cli
      pkgs.alt-tab-macos # windows like alt-tab
      pkgs.ansible # configuration management tool
      pkgs.coreutils # gnu core utils
      pkgs.dotnetCorePackages.sdk_8_0-bin
      pkgs.dotnetCorePackages.dotnet_9.sdk
      pkgs.duti # tool to set default apps
      pkgs.fzf # fuzzy finder
      pkgs.inetutils # gnu network utils
      pkgs.jetbrains-toolbox
      pkgs.kubectl # kubernetes cli
      pkgs.kubectx # kubernetes context tool
      pkgs.kubernetes-helm # package manager for kubernetes
      pkgs.meslo-lgs-nf # font for powerlevel10k
      pkgs.nmap # network discovery tool
      pkgs.nodejs_24
      pkgs.openssh # ssh tool
      pkgs.opentofu # open source fork of terraform
      pkgs.ripgrep # faster grep
      pkgs.spotify
      pkgs.uv # python package manager
      pkgs.zsh-powerlevel10k # zsh theme
    ]
    ++ [
      pkgs-unstable.docker # docker
      pkgs-unstable.helmfile #
      pkgs-unstable.k9s # kubernetes cluster manager
      pkgs-unstable.ollama # local llms
      pkgs-unstable.opencode # local agent
      pkgs-unstable.terraform # tool for building, changing, and versioning infrastructure
      pkgs-unstable.vault # hcp tool for managing secrets
      pkgs-unstable.velero # kubernetes cluster restore tool
    ];
}
