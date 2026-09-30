{ config, pkgs, lib, ... }:
{
  system.defaults.trackpad = {
    ActuationStrength = 0;
    Clicking = true;
    FirstClickThreshold = 0;
    SecondClickThreshold = 0;
    TrackpadPinch = true;
    TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
    TrackpadThreeFingerHorizSwipeGesture = 2;
    TrackpadThreeFingerTapGesture = 0;
  };

  system.defaults.NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false; # natural scrolling
      "com.apple.trackpad.scaling" = 3; # trackpad tracking speed
  };

    # Force macOS to re-read trackpad preferences
    system.activationScripts.postActivation.text = lib.mkAfter ''
      /usr/bin/killall cfprefsd 2>/dev/null || true
    '';
}