{
  targets.darwin.defaults = {
    "com.apple.finder" = {
      FXPreferredViewStyle = "Nlsv"; # list view default
      NewWindowTarget = "PfHm"; # home folder
      ShowPathbar = true; # shows the path bar on the bottom of finder
      QuitMenuItem = true; # allows quitting finder
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
