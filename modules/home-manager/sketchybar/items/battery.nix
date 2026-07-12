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

    cycles=$(ioreg -rn AppleSmartBattery 2>/dev/null \
      | awk -F'= ' '/"CycleCount"/ { print $2; exit }')
    # Apple's "Maximum Capacity" = NominalChargeCapacity / DesignCapacity.
    # (On Apple Silicon "MaxCapacity" is already a normalized 100, not mAh.)
    health=$(ioreg -rn AppleSmartBattery 2>/dev/null \
      | awk -F'= ' '/"NominalChargeCapacity"/ { nom=$2 } /"DesignCapacity"/ { des=$2 } END { if (des) printf "%.0f%%", nom / des * 100 }')

    ${sbar} --set battery.charge label="''${percent:-?}" \
            --set battery.status label="$status" \
            --set battery.time   label="$remaining" \
            --set battery.cycles label="''${cycles:-?}" \
            --set battery.health label="''${health:-?}"
  '';

  row = name: ''
    ${sbar} --add item ${name} popup.battery \
      --set ${name} \
        width=190 \
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
        click_script="${batteryDetail}; ${sbar} --set battery popup.drawing=toggle" \
      --subscribe battery power_source_change system_woke

    ${sbar} --add item battery.header popup.battery \
      --set battery.header \
        icon="${theme.icons.battery}  Battery" \
        icon.font="${theme.fonts.text}:Bold:13.0" \
        icon.color=${theme.colors.green} \
        icon.padding_left=10 \
        icon.padding_right=10 \
        label.drawing=off

    ${row "battery.charge"}
    ${sbar} --set battery.charge icon="Charge"
    ${row "battery.status"}
    ${sbar} --set battery.status icon="Status"
    ${row "battery.time"}
    ${sbar} --set battery.time icon="Time"
    ${row "battery.cycles"}
    ${sbar} --set battery.cycles icon="Cycles"
    ${row "battery.health"}
    ${sbar} --set battery.health icon="Health"
  '';

  init = "${updateBattery}";
}
