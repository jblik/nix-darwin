{
  pkgs,
  pkgs-unstable,
  profile,
  ...
}:
{
  imports = [
    ./${profile}/appearance.nix
  ];

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleIconAppearanceTheme = "RegularDark";
      AppleMetricUnits = 1;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";
      AppleICUForce24HourTime = true;
      NSStatusItemSelectionPadding = 0;
      NSStatusItemSpacing = 0;
    };

    loginwindow.GuestEnabled = false;

    menuExtraClock.IsAnalog = true;
  };
}
