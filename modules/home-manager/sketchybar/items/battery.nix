{ pkgs, sbar, theme, ... }:
let
  updateBattery = pkgs.writeShellScript "sketchybar-battery.sh" ''
    info=$(pmset -g batt)
    percent=$(echo "$info" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
    [ -z "$percent" ] && exit 0

    if [ "$percent" -ge 95 ]; then
      level=100
    elif [ "$percent" -ge 85 ]; then
      level=90
    elif [ "$percent" -ge 75 ]; then
      level=80
    elif [ "$percent" -ge 65 ]; then
      level=70
    elif [ "$percent" -ge 55 ]; then
      level=60
    elif [ "$percent" -ge 45 ]; then
      level=50
    elif [ "$percent" -ge 35 ]; then
      level=40
    elif [ "$percent" -ge 25 ]; then
      level=30
    elif [ "$percent" -ge 15 ]; then
      level=20
    else
      level=10
    fi

    if echo "$info" | grep -q "AC Power"; then
      color=${theme.colors.white}
      case "$level" in
        100) icon="${theme.icons.batteryCharging."100"}" ;;
        90) icon="${theme.icons.batteryCharging."90"}" ;;
        80) icon="${theme.icons.batteryCharging."80"}" ;;
        70) icon="${theme.icons.batteryCharging."70"}" ;;
        60) icon="${theme.icons.batteryCharging."60"}" ;;
        50) icon="${theme.icons.batteryCharging."50"}" ;;
        40) icon="${theme.icons.batteryCharging."40"}" ;;
        30) icon="${theme.icons.batteryCharging."30"}" ;;
        20) icon="${theme.icons.batteryCharging."20"}" ;;
        *) icon="${theme.icons.batteryCharging."10"}" ;;
      esac
    else
      if [ "$percent" -le 20 ]; then
        color=${theme.colors.red}
      elif [ "$percent" -le 50 ]; then
        color=${theme.colors.yellow}
      else
        color=${theme.colors.green}
      fi

      case "$level" in
        100) icon="${theme.icons.battery."100"}" ;;
        90) icon="${theme.icons.battery."90"}" ;;
        80) icon="${theme.icons.battery."80"}" ;;
        70) icon="${theme.icons.battery."70"}" ;;
        60) icon="${theme.icons.battery."60"}" ;;
        50) icon="${theme.icons.battery."50"}" ;;
        40) icon="${theme.icons.battery."40"}" ;;
        30) icon="${theme.icons.battery."30"}" ;;
        20) icon="${theme.icons.battery."20"}" ;;
        *) icon="${theme.icons.battery."10"}" ;;
      esac
    fi

    ${sbar} --set battery icon="$icon" icon.color="$color"
  '';

  batteryDetail = pkgs.writeShellScript "sketchybar-battery-detail.sh" ''
    info=$(pmset -g batt)
    percent=$(echo "$info" | grep -Eo '[0-9]+%' | head -1)

    if echo "$info" | grep -q "AC Power"; then
      if echo "$info" | grep -qi "charged"; then
        status="Charged"
      else
        status="Charging"
      fi
    else
      status="On battery"
    fi

    remaining=$(echo "$info" | grep -Eo '[0-9]+:[0-9]+' | head -1)
    [ -z "$remaining" ] && remaining="—"

    # Apple's "Maximum Capacity" = NominalChargeCapacity / DesignCapacity.
    # (On Apple Silicon "MaxCapacity" is already a normalized 100, not mAh.)
    health=$(ioreg -rn AppleSmartBattery 2>/dev/null \
      | awk -F'= ' '/"NominalChargeCapacity"/ { nom=$2 } /"DesignCapacity"/ { des=$2 } END { if (des) printf "%.0f%%", nom / des * 100 }')

    ${sbar} --set battery.charge label="''${percent:-?}" \
            --set battery.status label="$status" \
            --set battery.time   label="$remaining" \
            --set battery.health label="''${health:-?}"
  '';

  row = name: ''
    ${sbar} --add item ${name} popup.battery \
      --set ${name} \
        width=190 \
        icon.font="${theme.fonts.text}:Semibold:12.0" \
        icon.color=${theme.colors.white} \
        icon.align=left \
        label.font="${theme.fonts.text}:Semibold:12.0" \
        label.color=${theme.colors.lavender} \
        label.align=right

  '';
in
{
  config = ''
    ${sbar} --add item battery right \
      --set battery \
        icon=" ${theme.icons.battery."100"}" \
        icon.font="${theme.fonts.nerd}:Bold:26.0" \
        label.font="${theme.fonts.text}:Semibold:11.0" \
        label.align=center \
        update_freq=30 \
        background.padding_right=15 \
        script="${updateBattery}" \
        click_script="${batteryDetail}; ${sbar} --set battery popup.drawing=toggle popup.y_offset=-240" \
      --subscribe battery power_source_change system_woke

    ${sbar} --add item battery.header popup.battery \
      --set battery.header \
        icon="${theme.icons.battery."100"}  Battery" \
        icon.font="${theme.fonts.nerd}:Bold:13.0" \
        icon.color=${theme.colors.green} \
        label.drawing=off

    ${row "battery.charge"}
    ${sbar} --set battery.charge icon="Charge"
    ${row "battery.status"}
    ${sbar} --set battery.status icon="Status"
    ${row "battery.time"}
    ${sbar} --set battery.time icon="Time"
    ${row "battery.health"}
    ${sbar} --set battery.health icon="Health"
  '';

  init = "${updateBattery}";
}
