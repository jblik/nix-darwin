{ ... }:
{
  services.tailscale.enable = true;
#  services.tailscale.overrideLocalDns = true; # todo check if this works as expected -> don't think so
  # services.tailscale.package # todo if tailscale from nix doesn't work well then change this to come from mac app store

  #  launchd.user.agents = {
  #    # login items
  #  };
}
