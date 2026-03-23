{ username, ... }:

{
  services.tailscale.enable = true;
  # services.tailscale.overrideLocalDns = true; # todo check if this works as expected
  # services.tailscale.package # todo if tailscale from nix doesn't work well then change this to come from mac app store

  services.karabiner-elements.enable = true; # todo somehow not working on this machine now

  launchd.user.agents = {
    # login items
    stats = {
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = false;
        ProgramArguments = [
          "/usr/bin/open"
          "/Applications/Nix Apps/Stats.app"
        ];
      };
    };
    monitorcontrol = {
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = false;
        ProgramArguments = [
          "/usr/bin/open"
          "/Applications/Nix Apps/MonitorControl.app"
        ];
      };
    };
    alttab = {
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = false;
        ProgramArguments = [
          "/usr/bin/open"
          "/Applications/Nix Apps/AltTab.app"
        ];
      };
    };
  };
}
