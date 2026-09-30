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
      "/${pkgs.iterm2}/Applications/iTerm2.app"
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
      # "/Applications/Zen Browser.app"
      # "/Applications/Vivaldi.app"
      # "/Applications/Ghostty.app"
      # "/Applications/Cursor.app"
      # Use the nixpkgs path to the app for apps installed via nix. This will automatically use the latest nix store path.
      # "/${pkgs.lens}/Applications/Lens.app"
      # "/${pkgs.slack}/Applications/Slack.app"
      # "/${pkgs.discord}/Applications/Discord.app"
      # "/${pkgs.spotify}/Applications/Spotify.app"
      # "/Applications/joplin.app"
      # Add your persistent apps here
    ];
    persistent-others = [
      # "${homeDirectory}/code"
      "${homeDirectory}/Downloads"
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