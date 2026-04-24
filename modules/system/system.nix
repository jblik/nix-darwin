{
  pkgs,
  homeDirectory,
  username,
  ...
}:
{
  system = {
    defaults.screencapture.location = "${homeDirectory}/Documents/Screenshots";
    activationScripts.postActivation.text = ''
      echo "setting default apps with duti..."
      ${pkgs.duti}/bin/duti -s com.sublimetext.4 public.plain-text all
      ${pkgs.duti}/bin/duti -s com.sublimetext.4 .txt all
      ${pkgs.duti}/bin/duti -s com.sublimetext.4 .md all

      echo "disabling airplay receiver..."
      sudo -u ${username} /usr/bin/defaults -currentHost write com.apple.controlcenter.plist AirplayRecieverEnabled -bool false
    '';
  };
  security.pam.services.sudo_local.touchIdAuth = true;
}
