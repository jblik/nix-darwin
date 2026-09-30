{ config, pkgs, lib, username, ... }:
let
  homeDirectory = "/Users/${username}";
in
{  
  # If you also want to do e.g. Dock preferences from the same user-level file:
  system.defaults.dock = {
    autohide = true;
    orientation = "bottom";
    persistent-apps = [
      "/${pkgs.iterm2}/Applications/iTerm2.app" # Use the nixpkgs path to the app for apps installed via nix. This will automatically use the latest nix store path.
      "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
      # todo get these from nix as well
      "${homeDirectory}/Applications/Rider.app"
      "${homeDirectory}/Applications/DataGrip.app"
      "${homeDirectory}/Applications/IntelliJ IDEA.app"
      "${homeDirectory}/Applications/WebStorm.app"
      "${homeDirectory}/Applications/PyCharm.app"
      "${homeDirectory}/Applications/RustRover.app"
      "${homeDirectory}/Applications/CLion.app"
      "/System/Applications/Calendar.app"
      "/Applications/Sublime Text.app"
      "/System/Applications/Messages.app"
      "/System/Applications/System Settings.app"
      "/System/Applications/iPhone Mirroring.app"
    ];
    persistent-others = [
      # "${homeDirectory}/code"
      { folder = { path = "${homeDirectory}/Downloads"; arrangement = "date-added"; showas = "fan"; }; }
      # "${homeDirectory}/Applications/Home Manager Apps"
      # Add your persistent others here
    ];
    show-recents = true;
    tilesize = 62; # Set the icon size on the dock; default is 64
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