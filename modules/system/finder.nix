{
  system.defaults.finder = {
    FXPreferredViewStyle = "Nlsv"; # list view default
    NewWindowTarget = "Home";
    ShowPathbar = true; # shows the path bar on the bottom of finder
    QuitMenuItem = true; # allows quitting finder
    AppleShowAllFiles = true;
    AppleShowAllExtensions = true;
    ShowMountedServersOnDesktop = true;
    ShowRemovableMediaOnDesktop = true;
  };
  system.defaults.CustomUserPreferences = {
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
  };
}
