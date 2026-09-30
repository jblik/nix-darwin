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

      for ext in .txt .md .json .yaml .yml .toml .ini .cfg .log .csv \
                 .js .ts .tsx .fs .sh .zsh .bash .c .h .cpp \
                 .xml .sql public.plain-text; do
        ${lib.getExe pkgs.duti} -s com.sublimetext.4 $ext all
      done

      # echo "disabling airplay receiver..."
      # sudo -u ${user.username} /usr/bin/defaults -currentHost write com.apple.controlcenter.plist AirplayRecieverEnabled -bool false
    '';
  };
  security.pam.services.sudo_local.touchIdAuth = true;
}
