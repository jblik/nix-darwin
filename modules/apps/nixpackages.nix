{
  pkgs,
  pkgs-unstable,
  ...
}:
let
  dotnet = import ./dotnet.nix {
    buildDotnetGlobalTool = pkgs.buildDotnetGlobalTool;
    dotnetCorePackages = pkgs.dotnetCorePackages;
    lib = pkgs.lib;
  };
in
{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = [
  # todo patch jetbrains mono:https://wiki.nixos.org/wiki/Fonts
    pkgs.meslo-lgs-nf # font for powerlevel10k
  ];

  # https://search.nixos.org/packages
  environment.systemPackages = [
    pkgs.azure-cli
    pkgs.ansible # configuration management tool
    pkgs.coreutils # gnu core utils
    pkgs-unstable.docker # docker
    dotnet.nuke # for packaging dotnet projects
    dotnet.sdk # dotnet sdk
    pkgs.duti # tool to set default apps
    pkgs.fzf # fuzzy finder
    pkgs-unstable.helmfile
    pkgs.inetutils # gnu network utils
    pkgs.jetbrains-toolbox
    pkgs-unstable.k9s # kubernetes cluster manager
    pkgs.kubectl # kubernetes cli
    pkgs.kubectx # kubernetes context tool
    pkgs.kubernetes-helm # package manager for kubernetes
    pkgs.nmap # network discovery tool
    pkgs.nodejs_24
    pkgs-unstable.ollama # local llms
    pkgs-unstable.opencode # local agent
    pkgs.openssh # ssh tool
    pkgs.opentofu # open source fork of terraform
    pkgs.ripgrep # faster grep
    pkgs.spotify
    pkgs-unstable.terraform # tool for building, changing, and versioning infrastructure
    pkgs.uv # python package manager
    pkgs-unstable.vault # hcp tool for managing secrets
    pkgs-unstable.velero # kubernetes cluster restore tool
    pkgs.zsh-powerlevel10k # zsh theme
  ];
}
