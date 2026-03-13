# find these here: https://nix-darwin.github.io/nix-darwin/manual/index.html
{ config, lib, ... }:

{ 
  system.defaults.screencapture = {
    location = "~/Documents/Screenshots"; # Set default screenshot location
    # Add more screencapture settings here
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  

  
  
}