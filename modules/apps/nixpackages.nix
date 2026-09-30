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
    pkgs.meslo-lgs-nf # font for powerlevel10k
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # https://search.nixos.org/packages
  environment.systemPackages =
    with pkgs;
    [
      azure-cli
      ansible # configuration management tool
      coreutils # gnu core utils
      google-chrome
      gnupg # gpg
      dotnet.nuke # for packaging dotnet projects
      dotnet.sdk # dotnet sdk
      duti # tool to set default apps
      forgejo-cli
      forgejo-runner
      fzf # fuzzy finder
      inetutils # gnu network utils
      jetbrains-toolbox
      kubectl # kubernetes cli
      kubectx # kubernetes context tool
      kubernetes-helm # package manager for kubernetes
      nmap # network discovery tool
      nodejs_24
      openssh # ssh tool
      opentofu # open source fork of terraform
      rectangle
      ripgrep # faster grep
      spotify
      tailwindcss
      uv # python package manager
      zsh-powerlevel10k # zsh theme
    ]
    ++ (with pkgs-unstable; [
      docker # docker
      helmfile
      k9s # kubernetes cluster manager
      opencode # local agent
      # ollama # local llms todo: xcode install MLX Metal
      terraform # tool for building, changing, and versioning infrastructure
      vault # hcp tool for managing secrets
      velero # kubernetes cluster restore tool
    ]);
}
