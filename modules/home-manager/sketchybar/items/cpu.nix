{ pkgs, theme, sbar, ... }:
let
  sparkline = import ../helpers/sparkline.nix { inherit pkgs; };
  cache = "$HOME/.cache/sketchybar";

  updateCpu = pkgs.writeShellScript "sketchybar-cpu.sh" ''
    mkdir -p ${cache}
    idle=$(top -l 2 -n 0 -s 1 | awk '/CPU usage/ { gsub(/%/, "", $7); value = $7 } END { print value }')
    used=$(awk "BEGIN { printf \"%.0f\", 100 - $idle }")
    graph=$(${sparkline} "${cache}/cpu.hist" "$used" 7)
    ${sbar} --set cpu label="$graph"
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

  row = name: ''
    ${sbar} --add item ${name} popup.cpu \
      --set ${name} \
        width=176 \
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
    ${sbar} --add item cpu right \
      --set cpu \
        icon.drawing=off \
        label="▁▁▁▁▁▁▁" \
        label.font="${theme.fonts.nerd}:Bold:13.0" \
        label.color=${theme.colors.green} \
        label.padding_left=6 \
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

    ${row "cpu.user"}
    ${sbar} --set cpu.user icon="User"
    ${row "cpu.sys"}
    ${sbar} --set cpu.sys icon="System"
    ${row "cpu.idle"}
    ${sbar} --set cpu.idle icon="Idle"

    ${row "cpu.p1"}
    ${row "cpu.p2"}
    ${row "cpu.p3"}
    ${sbar} --set cpu.p1 label.color=${theme.colors.white} drawing=off \
            --set cpu.p2 label.color=${theme.colors.white} drawing=off \
            --set cpu.p3 label.color=${theme.colors.white} drawing=off
  '';

  init = "${updateCpu}";
}
