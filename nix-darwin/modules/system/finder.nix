{ config, pkgs, lib, ... }:

{
    system.defaults.finder = {
        FXPreferredViewStyle = "Nlsv";
        NewWindowTarget = "Home";
        ShowMountedServersOnDesktop = true;
        ShowPathbar = true;
    };

    system.defaults.NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
    };
}