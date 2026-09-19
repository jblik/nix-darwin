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
  starwars-jetbrains-mono = pkgs.callPackage ../fonts/starwars-jetbrains-mono.nix { };
in
{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    starwars-jetbrains-mono
    sketchybar-app-font
  ];

  # https://search.nixos.org/packages
  environment.systemPackages =
    with pkgs;
    [
      _1password-cli
      azure-cli
      ansible # configuration management tool
      bruno # foss postman
      codex
      container
      coreutils # gnu core utils
      dotnet.fallout # for packaging dotnet projects
      dotnet.sdk # dotnet sdk
      duti # tool to set default apps
      fastfetch # neofetch like
      fluxcd # gitops tool
      forgejo-cli
      forgejo-runner
      fzf # fuzzy finder
      git-lfs
      inetutils # gnu network utils
      jetbrains-toolbox
      jjui # ui for jj
      jujutsu # vcs
      kubectl # kubernetes cli
      kubectx # kubernetes context tool
      kubernetes-helm # package manager for kubernetes
      mas # Mac App Store command-line interface
      nmap # network discovery tool
      nodejs_26 # node
      opentofu # open source fork of terraform
      postgresql # just use postgres
      playball # baseball scoreboard tui
      ripgrep # faster grep
      spotify # music
      tailwindcss # css framework
      tmux # terminal multiplexer
      uv # python package manager
      yubikey-manager
      zsh-powerlevel10k # zsh theme
    ]
    ++ (with pkgs-unstable; [
      docker # docker
      helmfile # additional helm utils
      k9s # kubernetes cluster manager
      opencode # local agent
      terraform # tool for building, changing, and versioning infrastructure
      vault # hcp tool for managing secrets
      velero # kubernetes cluster restore tool
    ]);
}
