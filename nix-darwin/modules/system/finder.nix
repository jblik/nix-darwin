{ config, pkgs, lib, ... }:

{
  # Finder Settings
  system.defaults.finder = {
    FXPreferredViewStyle = "Nlsv";      # Set default view style to list view
    NewWindowTarget = "Home";           # Set default new window target to home folder
    ShowMountedServersOnDesktop = true; # Show mounted servers on desktop
    ShowPathbar = true;                 # Show path bar
    };

  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true; # Show all file extensions
    AppleShowAllFiles = true;      # Show hidden files
    };
}