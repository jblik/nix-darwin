{ pkgs, theme, sbar, ... }:
let
  mkRow = import ../helpers/popup-row.nix { inherit sbar theme; };

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
in
{
  config = ''
    ${sbar} --add item wifi right \
      --set wifi \
        icon="${theme.icons.wifi}" \
        icon.font="${theme.fonts.nerd}:Bold:20.0" \
        label.drawing=off \
        update_freq=30 \
        script="${updateNetwork}" \
        background.padding_right=15 \
        click_script="${networkDetail}; ${sbar} --set wifi popup.drawing=toggle" \
      --subscribe wifi wifi_change system_woke

    ${sbar} --add item wifi.header popup.wifi \
      --set wifi.header \
        icon="${theme.icons.wifi}  Network" \
        icon.font="${theme.fonts.nerd}:Bold:13.0" \
        icon.color=${theme.colors.blue} \
        label.drawing=off

    ${mkRow { name = "wifi.state"; parent = "wifi"; width = 220; }}
    ${sbar} --set wifi.state icon="Status"
    ${mkRow { name = "wifi.ssid"; parent = "wifi"; width = 220; }}
    ${sbar} --set wifi.ssid icon="SSID"
    ${mkRow { name = "wifi.ip"; parent = "wifi"; width = 220; labelColor = theme.colors.white; }}
    ${sbar} --set wifi.ip icon="IP"
    ${mkRow { name = "wifi.router"; parent = "wifi"; width = 220; labelColor = theme.colors.white; }}
    ${sbar} --set wifi.router icon="Router"
  '';

  init = "${updateNetwork}";
}
