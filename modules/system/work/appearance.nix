{
  pkgs,
  pkgs-unstable,
  users,
  ...
}:
{
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      persistent-apps = [
        "/Applications/Ghostty.app"
        "/Applications/IntelliJ IDEA.app"
        "/Applications/Rider.app"
        "/Applications/DataGrip.app"
        "/Applications/Sublime Text.app"
        {
          spacer = {
            small = true;
          };
        }
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "${pkgs.spotify}/Applications/Spotify.app"
        "/Applications/Microsoft Teams.app"
        "/Applications/Microsoft Outlook.app"
        "/System/Applications/System Settings.app"
        "/System/Applications/Utilities/Activity Monitor.app"
        {
          spacer = {
            small = true;
          };
        }
      ];
      persistent-others = [
        {
          folder = {
            path = "${users.work.homeDirectory}/Documents/Screenshots";
            arrangement = "date-added";
            showas = "fan";
          };
        }
        {
          folder = {
            path = "${users.work.homeDirectory}/Downloads";
            arrangement = "date-added";
            showas = "fan";
          };
        }
      ];
      autohide-delay = 0.0;
      show-recents = false;
      tilesize = 62;
    };

    # todo: consolidate equal ones in a base appearance
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleIconAppearanceTheme = "RegularDark";
      AppleMetricUnits = 1;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";
      AppleICUForce24HourTime = true;
      NSStatusItemSelectionPadding = 0;
      NSStatusItemSpacing = 1;
    };

    loginwindow = {
      GuestEnabled = false;
      LoginwindowText = "This is not the account you are looking for...";
    };

    menuExtraClock.IsAnalog = true;
  };
}
