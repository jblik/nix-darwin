{
  lib,
  pkgs,
  user,
  ...
}:
{
  system = {
    defaults.screencapture.location = "${user.homeDirectory}/Documents/Screenshots";
    activationScripts.postActivation.text = ''
      echo "setting default apps with duti..."
      ${lib.getExe pkgs.duti} -s com.sublimetext.4 public.plain-text all
      ${lib.getExe pkgs.duti} -s com.sublimetext.4 .txt all
      ${lib.getExe pkgs.duti} -s com.sublimetext.4 .md all
      ${lib.getExe pkgs.duti} -s com.sublimetext.4 .json all

      # echo "disabling airplay receiver..."
      # sudo -u ${user.username} /usr/bin/defaults -currentHost write com.apple.controlcenter.plist AirplayRecieverEnabled -bool false
    '';
  };
  security.pam.services.sudo_local.touchIdAuth = true;
}
