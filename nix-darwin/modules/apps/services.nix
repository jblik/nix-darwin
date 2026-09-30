{ config, pkgs, ... }:

{
  # Example: Tailscale, other system services
  # services.nix-daemon.enable = true;
  services.tailscale.enable = true;

  # make stats a login item
  launchd.user.agents.stats = {
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = false;
      ProgramArguments = [
        "/usr/bin/open"
        "-a"
        "Stats"
      ];
    };
  };

}
