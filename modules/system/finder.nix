{ ... }:

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

  #todo is this needed
  #    system.defaults.NSGlobalDomain = {
  #        AppleShowAllExtensions = true;
  #        AppleShowAllFiles = true;
  #    };
}
