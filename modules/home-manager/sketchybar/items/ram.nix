{ pkgs, theme, sbar, ... }:
let
  sparkline = import ../helpers/sparkline.nix { inherit pkgs; };
  mkRow = import ../helpers/popup-row.nix { inherit sbar theme; };
  cache = "$HOME/.cache/sketchybar";

  updateRam = pkgs.writeShellScript "sketchybar-ram.sh" ''
    mkdir -p ${cache}
    free=$(memory_pressure | awk -F': ' '/free percentage/ { gsub(/%/, "", $2); print $2 }')
    used=$((100 - free))

    if [ "$used" -ge 85 ]; then
      color=${theme.colors.red}
    elif [ "$used" -ge 65 ]; then
      color=${theme.colors.yellow}
    else
      color=${theme.colors.blue}
    fi

    graph=$(${sparkline} "${cache}/ram.hist" "$used" 7)
    ${sbar} --set ram icon="''${used}%" label="$graph" label.color="$color"
  '';

  ramDetail = pkgs.writeShellScript "sketchybar-ram-detail.sh" ''
    total=$(( $(sysctl -n hw.memsize) / 1073741824 ))
    free=$(memory_pressure | awk -F': ' '/free percentage/ { gsub(/%/, "", $2); print $2 }')
    used_pct=$((100 - free))
    used_gb=$(awk "BEGIN { printf \"%.1f\", $total * $used_pct / 100 }")
    swap=$(sysctl -n vm.swapusage | awk '{ print $6 }')

    args=(--set ram.used  label="''${used_gb} / ''${total} GB" \
          --set ram.usedp label="''${used_pct}%" \
          --set ram.swap  label="''${swap:-0}")

    mapfile -t procs < <(ps -Aceo pmem,comm -m 2>/dev/null | sed -n '2,4p')
    i=1
    for p in "''${procs[@]}"; do
      pct=$(echo "$p" | awk '{ print $1 }')
      name=$(echo "$p" | sed -E 's/^ *[0-9.]+ +//')
      args+=(--set "ram.p$i" icon="$name" label="''${pct}%" drawing=on)
      i=$((i + 1))
    done
    while [ "$i" -le 3 ]; do
      args+=(--set "ram.p$i" drawing=off)
      i=$((i + 1))
    done

    ${sbar} "''${args[@]}"
  '';
in
{
  config = ''
    ${sbar} --add item ram right \
      --set ram \
        icon.drawing=on \
        icon="0%" \
        icon.font="${theme.fonts.text}:Bold:11.0" \
        icon.color=${theme.colors.white} \
        icon.padding_left=3 \
        icon.padding_right=4 \
        label="▁▁▁▁▁▁▁" \
        label.font="${theme.fonts.nerd}:Bold:13.0" \
        label.color=${theme.colors.blue} \
        label.padding_left=3 \
        label.padding_right=6 \
        update_freq=5 \
        script="${updateRam}" \
        click_script="${ramDetail}; ${sbar} --set ram popup.drawing=toggle"

    ${sbar} --add item ram.header popup.ram \
      --set ram.header \
        icon="${theme.icons.ram}  Memory" \
        icon.font="${theme.fonts.text}:Bold:13.0" \
        icon.color=${theme.colors.blue} \
        icon.padding_left=10 \
        icon.padding_right=10 \
        label.drawing=off

    ${mkRow { name = "ram.used"; parent = "ram"; width = 196; }}
    ${sbar} --set ram.used icon="Used"
    ${mkRow { name = "ram.usedp"; parent = "ram"; width = 196; }}
    ${sbar} --set ram.usedp icon="Pressure"
    ${mkRow { name = "ram.swap"; parent = "ram"; width = 196; }}
    ${sbar} --set ram.swap icon="Swap"

    ${mkRow { name = "ram.p1"; parent = "ram"; width = 196; labelColor = theme.colors.white; }}
    ${mkRow { name = "ram.p2"; parent = "ram"; width = 196; labelColor = theme.colors.white; }}
    ${mkRow { name = "ram.p3"; parent = "ram"; width = 196; labelColor = theme.colors.white; }}
    ${sbar} --set ram.p1 drawing=off \
            --set ram.p2 drawing=off \
            --set ram.p3 drawing=off
  '';

  init = "${updateRam}";
}
