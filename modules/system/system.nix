{ pkgs, homeDirectory, ... }:

{
  system = {
    defaults.screencapture.location = "${homeDirectory}/Documents/Screenshots";
    activationScripts.setDefaultApps = {
      enable = true;
      text = ''
        echo "Setting default apps with duti..." >&2
        # Set Sublime Text as default for unknown/generic file types
        ${pkgs.duti}/bin/duti -s com.sublimetext.4 public.data all
        ${pkgs.duti}/bin/duti -s com.sublimetext.4 public.plain-text all
        ${pkgs.duti}/bin/duti -s com.sublimetext.4 public.content all
      '';
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;
}
