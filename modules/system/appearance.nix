{
  pkgs-unstable,
  users,
  ...
}:
# todo: need to make this multi-user
{
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      persistent-apps = [
        "/Applications/Ghostty.app"
        "${pkgs-unstable.jetbrains.idea}/Applications/IntelliJ IDEA.app"
        "${pkgs-unstable.jetbrains.rider}/Applications/Rider.app"
        "${pkgs-unstable.jetbrains.datagrip}/Applications/DataGrip.app"
        "/Applications/Sublime Text.app"
        {
          spacer = {
            small = true;
          };
        }
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "/System/Applications/Microsoft Teams.app.app"
        "/System/Applications/System Settings.app"
        "/System/Applications/Utilities/Activity Monitor.app"
        "/System/Applications/iPhone Mirroring.app"
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

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleIconAppearanceTheme = "RegularDark";
      AppleMetricUnits = 1;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";
      AppleICUForce24HourTime = true;
    };

    loginwindow = {
      GuestEnabled = false;
      LoginwindowText = "Welcome!";
    };

    menuExtraClock.IsAnalog = true;
  };
}
