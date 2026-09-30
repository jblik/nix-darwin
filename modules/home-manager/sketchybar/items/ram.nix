{ pkgs, theme, sbar, ... }:
let
  donut = import ../helpers/donut.nix { inherit pkgs; };
  cache = "$HOME/.cache/sketchybar";

  # Convert a sketchybar "0xaarrggbb" color to an ImageMagick "#rrggbb".
  toHex = c: "#" + builtins.substring 4 6 c;

  updateRam = pkgs.writeShellScript "sketchybar-ram.sh" ''
    mkdir -p ${cache}
    free=$(memory_pressure | awk -F': ' '/free percentage/ { gsub(/%/, "", $2); print $2 }')
    used=$((100 - free))

    if [ "$used" -ge 85 ]; then
      color="${toHex theme.colors.red}"
    elif [ "$used" -ge 65 ]; then
      color="${toHex theme.colors.yellow}"
    else
      color="${toHex theme.colors.blue}"
    fi

    img="${cache}/ram-donut.png"
    ${donut} "$img" "$used" "$color" "${toHex theme.colors.itemBackground}"
    ${sbar} --set ram background.image="$img" label="''${used}%"
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

  row = name: ''
    ${sbar} --add item ${name} popup.ram \
      --set ${name} \
        width=196 \
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
    ${sbar} --add item ram right \
      --set ram \
        icon.drawing=off \
        label="0%" \
        label.font="${theme.fonts.text}:Bold:11.0" \
        label.color=${theme.colors.white} \
        label.align=center \
        label.padding_left=0 \
        label.padding_right=0 \
        background.image.scale=0.5 \
        background.padding_left=3 \
        background.padding_right=3 \
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

    ${row "ram.used"}
    ${sbar} --set ram.used icon="Used"
    ${row "ram.usedp"}
    ${sbar} --set ram.usedp icon="Pressure"
    ${row "ram.swap"}
    ${sbar} --set ram.swap icon="Swap"

    ${row "ram.p1"}
    ${row "ram.p2"}
    ${row "ram.p3"}
    ${sbar} --set ram.p1 label.color=${theme.colors.white} drawing=off \
            --set ram.p2 label.color=${theme.colors.white} drawing=off \
            --set ram.p3 label.color=${theme.colors.white} drawing=off
  '';

  init = "${updateRam}";
}
