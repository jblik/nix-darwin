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

  networkDetail = pkgs.writeShellScript "sketchybar-network-detail.sh" ''
    device=$(networksetup -listallhardwareports | awk '/Wi-Fi/ { getline; print $2 }')
    [ -z "$device" ] && device=en0

    address=$(ipconfig getifaddr "$device" 2>/dev/null)
    router=$(route -n get default 2>/dev/null | awk '/gateway/ { print $2 }')
    ssid=$(ipconfig getsummary "$device" 2>/dev/null | awk -F' SSID : ' '/ SSID : / { print $2; exit }')

    if [ -n "$address" ]; then
      state="Connected"
    else
      state="Offline"
    fi

    ${sbar} --set wifi.state  label="$state" \
            --set wifi.ssid   label="''${ssid:-—}" \
            --set wifi.ip     label="''${address:-—}" \
            --set wifi.router label="''${router:-—}"
  '';

  row = name: ''
    ${sbar} --add item ${name} popup.wifi \
      --set ${name} \
        width=220 \
        icon.font="${theme.fonts.text}:Semibold:12.0" \
        icon.color=${theme.colors.white} \
        icon.padding_left=10 \
        icon.align=left \
        label.font="${theme.fonts.text}:Semibold:12.0" \
        label.color=${theme.colors.lavender} \
        label.padding_right=10 \
        label.align=right
  '';
in
{
  config = ''
    ${sbar} --add item wifi right \
      --set wifi \
        icon="${theme.icons.wifi}" \
        icon.font="${theme.fonts.nerd}:Bold:20.0" \
        icon.padding_left=6 \
        icon.padding_right=6 \
        label.drawing=off \
        update_freq=10 \
        script="${updateNetwork}" \
        click_script="${networkDetail}; ${sbar} --set wifi popup.drawing=toggle popup.y_offset=-240" \
      --subscribe wifi wifi_change system_woke

    ${sbar} --add item wifi.header popup.wifi \
      --set wifi.header \
        icon="${theme.icons.wifi}  Network" \
        icon.font="${theme.fonts.nerd}:Bold:13.0" \
        icon.color=${theme.colors.blue} \
        icon.padding_left=10 \
        icon.padding_right=10 \
        label.drawing=off

    ${row "wifi.state"}
    ${sbar} --set wifi.state icon="Status"
    ${row "wifi.ssid"}
    ${sbar} --set wifi.ssid icon="SSID"
    ${row "wifi.ip"}
    ${sbar} --set wifi.ip icon="IP" label.color=${theme.colors.white}
    ${row "wifi.router"}
    ${sbar} --set wifi.router icon="Router" label.color=${theme.colors.white}
  '';

  init = "${updateNetwork}";
}
