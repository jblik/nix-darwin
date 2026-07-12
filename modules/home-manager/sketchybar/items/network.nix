{ pkgs, theme, sbar, ... }:
let
  updateNetwork = pkgs.writeShellScript "sketchybar-network.sh" ''
    device=$(networksetup -listallhardwareports | awk '/Wi-Fi/ { getline; print $2 }')
    [ -z "$device" ] && device=en0
    address=$(ipconfig getifaddr "$device" 2>/dev/null)

    if [ -n "$address" ]; then
      ${sbar} --set wifi icon.color=${theme.colors.white}
    else
      ${sbar} --set wifi icon.color=${theme.colors.red}
    fi
  '';
in
{
  config = ''
    ${sbar} --add item wifi right \
      --set wifi \
        icon="${theme.icons.wifi}" \
        icon.font="${theme.fonts.nerd}:Bold:14.0" \
        icon.padding_left=6 \
        icon.padding_right=6 \
        label.drawing=off \
        update_freq=10 \
        script="${updateNetwork}" \
      --subscribe wifi wifi_change system_woke
  '';

  init = "${updateNetwork}";
}
