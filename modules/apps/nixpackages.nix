{ pkgs, pkgs-unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
#  todo make dotnet properly
#  environment.variables.DOTNET_ROOT = "${combinedSdk}/share/dotnet/";

  # https://search.nixos.org/packages
  environment.systemPackages = with pkgs; [
    azure-cli
    ansible # configuration management tool
    coreutils # gnu core utils
    pkgs-unstable.docker # docker
    (
      with pkgs-unstable.dotnetCorePackages;
      combinePackages [
        sdk_8_0
        sdk_9_0
        sdk_10_0
      ]
    )
    duti # tool to set default apps
    fzf # fuzzy finder
    pkgs-unstable.helmfile
    inetutils # gnu network utils
    jetbrains-toolbox
    pkgs-unstable.k9s # kubernetes cluster manager
    kubectl # kubernetes cli
    kubectx # kubernetes context tool
    kubernetes-helm # package manager for kubernetes
    meslo-lgs-nf # font for powerlevel10k
    nmap # network discovery tool
    nodejs_24
    pkgs-unstable.ollama # local llms
    pkgs-unstable.opencode # local agent
    openssh # ssh tool
    opentofu # open source fork of terraform
    ripgrep # faster grep
    spotify
    pkgs-unstable.terraform # tool for building, changing, and versioning infrastructure
    uv # python package manager
    pkgs-unstable.vault # hcp tool for managing secrets
    pkgs-unstable.velero # kubernetes cluster restore tool
    zsh-powerlevel10k # zsh theme
  ];
}
