{ pkgs, theme, sbar, ... }:
let
  updateBattery = pkgs.writeShellScript "sketchybar-battery.sh" ''
    info=$(pmset -g batt)
    percent=$(echo "$info" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
    [ -z "$percent" ] && exit 0

    if echo "$info" | grep -q "AC Power"; then
      color=${theme.colors.green}
    elif [ "$percent" -le 20 ]; then
      color=${theme.colors.red}
    elif [ "$percent" -le 50 ]; then
      color=${theme.colors.yellow}
    else
      color=${theme.colors.white}
    fi

    ${sbar} --set battery label="''${percent}%" icon.color="$color"
  '';
in
{
  config = ''
    ${sbar} --add item battery right \
      --set battery \
        icon="${theme.icons.battery}" \
        icon.font="${theme.fonts.nerd}:Bold:14.0" \
        icon.padding_left=6 \
        icon.padding_right=3 \
        label.font="${theme.fonts.text}:Semibold:11.0" \
        label.padding_left=0 \
        label.padding_right=6 \
        update_freq=30 \
        script="${updateBattery}" \
      --subscribe battery power_source_change system_woke
  '';

  init = "${updateBattery}";
}
