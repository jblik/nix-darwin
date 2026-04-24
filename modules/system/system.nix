{ pkgs, homeDirectory, ... }:
{
  system = {
    defaults.screencapture.location = "${homeDirectory}/Documents/Screenshots";
    #    todo find out why this doesn't work here
    activationScripts.postActivation.text = ''
      echo "Setting default apps with duti..." >&2
      # Set Sublime Text as default for unknown/generic file types
      ${pkgs.duti}/bin/duti -s com.sublimetext.4 public.plain-text all
      ${pkgs.duti}/bin/duti -s com.sublimetext.4 .txt all
      ${pkgs.duti}/bin/duti -s com.sublimetext.4 .md all
    '';
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  # todo: disable airplay receiver (runs on port 5000 always)
}
