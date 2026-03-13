# find these here: https://nix-darwin.github.io/nix-darwin/manual/index.html
{ config, pkgs, lib, ... }:

{ 
    system.defaults.screencapture = {
        location = "~/Documents/Screenshots"; # Set default screenshot location
        # Add more screencapture settings here
    };

    security.pam.services.sudo_local.touchIdAuth = true;
    
    system.activationScripts.setDefaultApps = {
        enable = true;
        text = ''
            echo "Setting default apps with duti..." >&2
            # Set Sublime Text as default for unknown/generic file types
            ${pkgs.duti}/bin/duti -s com.sublimetext.4 public.data all
            ${pkgs.duti}/bin/duti -s com.sublimetext.4 public.plain-text all
            ${pkgs.duti}/bin/duti -s com.sublimetext.4 public.content all
        '';
    };
}