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

  fonts.packages = with pkgs; [
    # meslo-lgs-nf # font for powerlevel10k
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # https://search.nixos.org/packages
  environment.systemPackages =
    with pkgs;
    [
      alt-tab-macos
      azure-cli
      ansible # configuration management tool
      coreutils # gnu core utils
      google-chrome
      gnupg # gpg todo: configure this and pinentry also with home-manager
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
      mas # Mac App Store command-line interface
      nmap # network discovery tool
      nodejs_24
      opentofu # open source fork of terraform
      playball
      ripgrep # faster grep
      spotify
      shortcat
      stats
      tailwindcss
      tmux
      uv # python package manager
      zsh-powerlevel10k # zsh theme
    ]
    ++ (with pkgs-unstable; [
      docker # docker
      helmfile
      k9s # kubernetes cluster manager
      opencode # local agent
      ollama # local llms
      terraform # tool for building, changing, and versioning infrastructure
      vault # hcp tool for managing secrets
      velero # kubernetes cluster restore tool
    ]);
}
