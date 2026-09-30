{ config, pkgs, pkgs-unstable, lib, username, ... }:

{  
    system.defaults.dock = {
        autohide = true;
        orientation = "bottom";
        persistent-apps = [
            "/Applications/Ghostty.app"
            "${pkgs-unstable.jetbrains.rider}/Applications/Rider.app"
            "${pkgs-unstable.jetbrains.datagrip}/Applications/DataGrip.app"
            "~/Applications/IntelliJ IDEA.app"
            "~/Applications/WebStorm.app"
            "${pkgs-unstable.jetbrains.pycharm}/Applications/PyCharm.app"
            "~/Applications/RustRover.app"
            "~/Applications/CLion.app"
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
            { folder = { path = "~/Documents/Screenshots"; arrangement = "date-added"; showas = "fan"; }; }
            { folder = { path = "~/Downloads"; arrangement = "date-added"; showas = "fan"; }; }
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