{ config, pkgs ,pkgs-unstable, lib, username, ... }:
let
  homeDirectory = "/Users/${username}";
in
{  
  # If you also want to do e.g. Dock preferences from the same user-level file:
  system.defaults.dock = {
    autohide = true;
    orientation = "bottom";
    persistent-apps = [
      "${pkgs.ghostty-bin}/Applications/Ghostty.app"
      "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
      "${pkgs-unstable.jetbrains.rider}/Applications/Rider.app"
      "${homeDirectory}/Applications/DataGrip.app"
      "${homeDirectory}/Applications/IntelliJ IDEA.app"
      "${homeDirectory}/Applications/WebStorm.app"
      "${pkgs-unstable.jetbrains.pycharm}/Applications/PyCharm.app"
      "${homeDirectory}/Applications/RustRover.app"
      "${homeDirectory}/Applications/CLion.app"
      "/System/Applications/Calendar.app"
      "/Applications/Sublime Text.app"
      "/System/Applications/Messages.app"
      "/System/Applications/System Settings.app"
      "/System/Applications/iPhone Mirroring.app"
    ];
    persistent-others = [
      { folder = { path = "${homeDirectory}/Documents/Screenshots"; arrangement = "date-added"; showas = "fan"; }; }
      { folder = { path = "${homeDirectory}/Downloads"; arrangement = "date-added"; showas = "fan"; }; }
      # "${homeDirectory}/Applications/Home Manager Apps"
    ];
    show-recents = true;
    tilesize = 62;
  };

  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";     # "Dark" or "Light"
    # Add more NSGlobalDomain settings here
  };

  system.defaults.loginwindow = {
    GuestEnabled = false; # Disable guest account
    LoginwindowText = "Is this yours?"; # Set login window text
    # Add more loginwindow settings here
  };
}