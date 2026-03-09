{ config, pkgs, lib, ... }:

{
  # Darwin-level Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    brews = [
#      "argoproj/homebrew-tap/kubectl-argo-rollouts"
#      "gh"
#      "git"
#      "helm"
#      "k9s"
#      "ansible"
    ];
    # todo: why are these in homebrew anyways? this shit outdated asf 
    casks = [
#      "alt-tab"
#      "dotnet-sdk"
#      "ghostty"
#      "monitorcontrol"
#      "stats"
    ];
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
