{ pkgs, pkgs-unstable, username, ... }:
let
  homeDirectory = "/Users/${username}";
in
{  
    system.defaults.dock = {
        autohide = true;
        orientation = "bottom";
        persistent-apps = [
            "/Applications/Ghostty.app"
            "${pkgs-unstable.jetbrains.rider}/Applications/Rider.app"
            "${pkgs-unstable.jetbrains.datagrip}/Applications/DataGrip.app"
            "${homeDirectory}/Applications/IntelliJ IDEA.app"
            "${homeDirectory}/Applications/WebStorm.app"
            "${pkgs-unstable.jetbrains.pycharm}/Applications/PyCharm.app"
            "${homeDirectory}/Applications/RustRover.app"
            "${homeDirectory}/Applications/CLion.app"
            "/Applications/Sublime Text.app"
            { spacer = { small = true; }; }
            "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
            "/System/Applications/Messages.app"
            "/System/Applications/System Settings.app"
            "/System/Applications/Utilities/Activity Monitor.app"
            "/System/Applications/iPhone Mirroring.app"
            { spacer = { small = true; }; }
        ];
        persistent-others = [
            { folder = { path = "${homeDirectory}/Documents/Screenshots"; arrangement = "date-added"; showas = "fan"; }; }
            { folder = { path = "${homeDirectory}/Downloads"; arrangement = "date-added"; showas = "fan"; }; }
        ];
        autohide-delay = 0.0;
        show-recents = false;
        tilesize = 62;
    };

    system.defaults.NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleIconAppearanceTheme = "RegularDark";
        AppleMetricUnits = 1;
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";
        AppleICUForce24HourTime = true;
    };

    system.defaults.loginwindow = {
        GuestEnabled = false;
        LoginwindowText = "What are you doing?";
    };
    
    system.defaults.menuExtraClock.IsAnalog = true;
}