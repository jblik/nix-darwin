{
  pkgs,
  pkgs-unstable,
  user,
  ...
}:
{
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      persistent-apps = import ./${user.profile}/persistentApps.nix pkgs;
      persistent-others = [
        {
          folder = {
            path = "${user.homeDirectory}/Documents/Screenshots";
            arrangement = "date-added";
            showas = "fan";
          };
        }
        {
          folder = {
            path = "${user.homeDirectory}/Downloads";
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
      NSStatusItemSelectionPadding = 1;
      NSStatusItemSpacing = 1;
    };

    loginwindow = {
      GuestEnabled = false;
      LoginwindowText = "This is not the account you are looking for...";
    };

    menuExtraClock.IsAnalog = true;

    WindowManager.EnableStandardClickToShowDesktop = false;
  };
}
