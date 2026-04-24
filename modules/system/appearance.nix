{
  pkgs-unstable,
  users,
  ...
}:
{
  system = {
    # https://nix-darwin.github.io/nix-darwin/manual/#opt-system.defaults.NSGlobalDomain.NSStatusItemSelectionPadding
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
      LoginwindowText = "";
    };

    menuExtraClock.IsAnalog = true;
  };
}
