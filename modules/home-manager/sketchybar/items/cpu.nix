{ pkgs, theme, sbar, ... }:
let
  sparkline = import ../helpers/sparkline.nix { inherit pkgs; };
  mkRow = import ../helpers/popup-row.nix { inherit sbar theme; };
  cache = "$HOME/.cache/sketchybar";

  updateCpu = pkgs.writeShellScript "sketchybar-cpu.sh" ''
    mkdir -p ${cache}
    idle=$(top -l 2 -n 0 -s 1 | awk '/CPU usage/ { gsub(/%/, "", $7); value = $7 } END { print value }')
    used=$(awk "BEGIN { printf \"%.0f\", 100 - $idle }")
    graph=$(${sparkline} "${cache}/cpu.hist" "$used" 7)
    ${sbar} --set cpu icon="''${used}%" label="$graph"
  '';

  cpuDetail = pkgs.writeShellScript "sketchybar-cpu-detail.sh" ''
    line=$(top -l 1 -n 0 | grep -m1 'CPU usage')
    user=$(echo "$line" | awk '{ print $3 }')
    sys=$(echo "$line" | awk '{ print $5 }')
    idle=$(echo "$line" | awk '{ print $7 }')

    args=(--set cpu.user label="''${user:-?}" \
          --set cpu.sys  label="''${sys:-?}" \
          --set cpu.idle label="''${idle:-?}")

    mapfile -t procs < <(ps -Aceo pcpu,comm -r 2>/dev/null | sed -n '2,4p')
    i=1
    for p in "''${procs[@]}"; do
      pct=$(echo "$p" | awk '{ print $1 }')
      name=$(echo "$p" | sed -E 's/^ *[0-9.]+ +//')
      args+=(--set "cpu.p$i" icon="$name" label="''${pct}%" drawing=on)
      i=$((i + 1))
    done
    while [ "$i" -le 3 ]; do
      args+=(--set "cpu.p$i" drawing=off)
      i=$((i + 1))
    done

    ${sbar} "''${args[@]}"
  '';
in
{
  config = ''
    ${sbar} --add item cpu right \
      --set cpu \
        icon.drawing=on \
        icon="0%" \
        icon.font="${theme.fonts.text}:Bold:11.0" \
        icon.color=${theme.colors.white} \
        icon.padding_left=3 \
        icon.padding_right=4 \
        label="▁▁▁▁▁▁▁" \
        label.font="${theme.fonts.nerd}:Bold:13.0" \
        label.color=${theme.colors.green} \
        label.padding_left=3 \
        label.padding_right=6 \
        update_freq=5 \
        script="${updateCpu}" \
        click_script="${cpuDetail}; ${sbar} --set cpu popup.drawing=toggle"

    ${sbar} --add item cpu.header popup.cpu \
      --set cpu.header \
        icon="${theme.icons.cpu}  CPU" \
        icon.font="${theme.fonts.text}:Bold:13.0" \
        icon.color=${theme.colors.green} \
        icon.padding_left=10 \
        icon.padding_right=10 \
        label.drawing=off

    ${mkRow { name = "cpu.user"; parent = "cpu"; width = 176; }}
    ${sbar} --set cpu.user icon="User"
    ${mkRow { name = "cpu.sys"; parent = "cpu"; width = 176; }}
    ${sbar} --set cpu.sys icon="System"
    ${mkRow { name = "cpu.idle"; parent = "cpu"; width = 176; }}
    ${sbar} --set cpu.idle icon="Idle"

    ${mkRow { name = "cpu.p1"; parent = "cpu"; width = 176; labelColor = theme.colors.white; }}
    ${mkRow { name = "cpu.p2"; parent = "cpu"; width = 176; labelColor = theme.colors.white; }}
    ${mkRow { name = "cpu.p3"; parent = "cpu"; width = 176; labelColor = theme.colors.white; }}
    ${sbar} --set cpu.p1 drawing=off \
            --set cpu.p2 drawing=off \
            --set cpu.p3 drawing=off
  '';

  init = "${updateCpu}";
}
