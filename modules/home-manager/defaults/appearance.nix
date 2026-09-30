{
  config,
  pkgs,
  user,
  ...
}:
let
  appTile = item: {
    tile-data.file-data = {
      _CFURLString = item;
      _CFURLStringType = 0;
    };
  };

  spacerTile = item: {
    tile-data = { };
    tile-type = if item.spacer.small then "small-spacer-tile" else "spacer-tile";
  };

  # values are the ones the dock uses for date-added arrangement and grid view
  folderTile = path: {
    tile-data = {
      file-data = {
        _CFURLString = "file://${path}";
        _CFURLStringType = 15;
      };
      arrangement = 2;
      displayas = 0;
      showas = 2;
    };
    tile-type = "directory-tile";
  };
in
{
  targets.darwin.defaults = {
    "com.apple.dock" = {
      autohide = true;
      orientation = "right";
      persistent-apps = map (item: if builtins.isString item then appTile item else spacerTile item) (
        import ../${user.profile}/persistent-dock-apps.nix pkgs
      );
      persistent-others = [
        (folderTile "${config.home.homeDirectory}/Documents/Screenshots")
        (folderTile "${config.home.homeDirectory}/Downloads")
      ];
      autohide-delay = 0.0;
      show-recents = false;
      tilesize = 50;
      # mission control for aerospace
      mru-spaces = false;
    };
    "com.apple.spaces".spans-displays = false;

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleIconAppearanceTheme = "RegularDark";
      AppleMetricUnits = true;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";
      AppleICUForce24HourTime = true;
      NSStatusItemSelectionPadding = 5;
      NSStatusItemSpacing = 5;
      _HIHideMenuBar = true;
    };

    "com.apple.menuextra.clock".IsAnalog = true;

    "com.apple.WindowManager".EnableStandardClickToShowDesktop = false;

    "com.apple.screencapture".location = "${config.home.homeDirectory}/Documents/Screenshots";
  };

  # this takes port 5000; think about if you want this disabled
  # targets.darwin.currentHostDefaults."com.apple.controlcenter".AirplayRecieverEnabled = false;
}
