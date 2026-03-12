# find these here: https://nix-darwin.github.io/nix-darwin/manual/index.html
{ config, lib, ... }:

{ 
  system.defaults.screencapture = {
    location = "~/Documents/Screenshots"; # Set default screenshot location
    # Add more screencapture settings here
  };


  system.defaults.trackpad = {
    ActuationStrength = 0; # haptic feedback
    Clicking = true; # tap to click
    FirstClickThreshold = 0; # up to 2: force required
    SecondClickThreshold = 0; # up to 2: force required
    TrackpadPinch = true; # pinch to zoom
    TrackpadTwoFingerFromRightEdgeSwipeGesture = 3; # notification center swipe
    TrackpadThreeFingerHorizSwipeGesture = 2;
    TrackpadThreeFingerTapGesture = 0;

  };

  system.keyboard = {
    swapLeftCtrlAndFn = false; # Swap left control and function keys
    enableKeyMapping = true; # Enable key mapping
    # Set up your keyboard preferences here
  };

  # KEYBOARD SHORTCUTS 
    system.defaults.CustomUserPreferences = {
      NSGlobalDomain = {
        NSUserKeyEquivalents = {
            "Move to SAMSUNG" = "@^~\\Uf703"; # Cmd+Ctrl+Alt+Right Arrow
            "Move to E241N" = "@^~\\Uf702";
      };
    };
  };
  
  # check this:
  # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.CustomSystemPreferences
  # can also think about system.defaults.CustomUserPreferences instead
  system.defaults.CustomSystemPreferences = {
    "com.apple.Safari" = {
      "com.apple.Safari.NSUserKeyEquivalents.Close Web Inspector" = "\\Uf70f"; # f12
      "com.apple.Safari.NSUserKeyEquivalents.Show Web Inspector" = "\\Uf70f"; # f12
    };
  };

  system.defaults.NSGlobalDomain = {
    "com.apple.swipescrolldirection" = false;
    "com.apple.keyboard.fnState" = true; # use f keys as f keys
  };
}