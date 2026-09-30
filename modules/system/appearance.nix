{
  pkgs,
  user,
  ...
}:
{
  system.defaults = {
    dock = {
      autohide = false;
      orientation = "left";
      persistent-apps = import ./${user.profile}/persistentApps.nix pkgs;
      persistent-others = [
        {
          folder = {
            path = "${user.homeDirectory}/Documents/Screenshots";
            arrangement = "date-added";
            showas = "grid";
          };
        }
        {
          folder = {
            path = "${user.homeDirectory}/Downloads";
            arrangement = "date-added";
            showas = "grid";
          };
        }
      ];
      autohide-delay = 0.0;
      show-recents = false;
      tilesize = 50;
      # mission control for aerospace
      mru-spaces = false;
    };
    spaces.spans-displays = false;

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleIconAppearanceTheme = "RegularDark";
      AppleMetricUnits = 1;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";
      AppleICUForce24HourTime = true;
      NSStatusItemSelectionPadding = 5;
      NSStatusItemSpacing = 5;
    };

    loginwindow = {
      GuestEnabled = false;
      LoginwindowText = "This is not the account you are looking for...";
    };

    menuExtraClock.IsAnalog = true;

    WindowManager.EnableStandardClickToShowDesktop = false;
  };
}
