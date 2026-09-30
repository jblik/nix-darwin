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
  
  system.defaults.dock = {
    showDesktopGestureEnabled = true;
    showMissionControlGestureEnabled = true;
    showLaunchpadGestureEnabled = false;  
  };

  system.defaults.NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false; # natural scrolling
      "com.apple.trackpad.scaling" = 3.0; # trackpad tracking speed
      AppleEnableSwipeNavigateWithScrolls = false; # enable swipe to navigate backwards & forwards
      AppleEnableMouseSwipeNavigateWithScrolls = false; # enable swipe to navigate backwards & forwards
  };
}