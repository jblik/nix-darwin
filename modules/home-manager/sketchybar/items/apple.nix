{ pkgs, lib, theme, sbar, ... }:
let
  closePopup = "${sbar} --set apple.logo popup.drawing=off";
  togglePopup = "${sbar} --set \\$NAME popup.drawing=toggle";
in
{
  config = ''
    ${sbar} --add item apple.logo left \
      --set apple.logo \
        icon="${theme.icons.apple}" \
        icon.font="${theme.fonts.nerd}:Bold:16.0" \
        icon.color=${theme.colors.green} \
        background.padding_right=15 \
        label.drawing=off \
        click_script="${togglePopup}" \
      --add item apple.prefs popup.apple.logo \
      --set apple.prefs \
        icon="${theme.icons.preferences}" \
        icon.font="${theme.fonts.nerd}:Bold:16.0" \
        label="Preferences" \
        click_script="open -a 'System Settings'; ${closePopup}" \
      --add item apple.activity popup.apple.logo \
      --set apple.activity \
        icon="${theme.icons.activity}" \
        icon.font="${theme.fonts.nerd}:Bold:16.0" \
        label="Activity" \
        click_script="open -a 'Activity Monitor'; ${closePopup}" \
      --add item apple.lock popup.apple.logo \
      --set apple.lock \
        icon="${theme.icons.lock}" \
        icon.font="${theme.fonts.nerd}:Bold:16.0" \
        label="Lock Screen" \
        click_script="pmset displaysleepnow; ${closePopup}"
  '';
}
