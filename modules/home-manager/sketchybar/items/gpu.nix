{ pkgs, theme, sbar, ... }:
let
  sparkline = import ../helpers/sparkline.nix { inherit pkgs; };
  mkRow = import ../helpers/popup-row.nix { inherit sbar theme; };
  cache = "$HOME/.cache/sketchybar";

  readGpu = ''ioreg -r -d 1 -w 0 -c IOAccelerator \
      | grep -o '"Device Utilization %"=[0-9]*' \
      | head -1 \
      | grep -o '[0-9]*$' '';

  updateGpu = pkgs.writeShellScript "sketchybar-gpu.sh" ''
    mkdir -p ${cache}
    used=$(${readGpu})
    used=''${used:-0}
    graph=$(${sparkline} "${cache}/gpu.hist" "$used" 7)
    ${sbar} --set gpu icon="''${used}%" label="$graph"
  '';

  gpuDetail = pkgs.writeShellScript "sketchybar-gpu-detail.sh" ''
    used=$(${readGpu})
    name=$(ioreg -r -d 1 -w 0 -c IOAccelerator \
      | grep -o '"model"=<"[^"]*"' \
      | head -1 \
      | sed -E 's/.*<"//')
    ${sbar} --set gpu.util label="''${used:-0}%" \
            --set gpu.model label="''${name:-Apple GPU}"
  '';
in
{
  config = ''
    ${sbar} --add item gpu right \
      --set gpu \
        icon.drawing=on \
        icon="0%" \
        icon.font="${theme.fonts.text}:Bold:11.0" \
        icon.color=${theme.colors.white} \
        icon.padding_left=3 \
        icon.padding_right=4 \
        label="▁▁▁▁▁▁▁" \
        label.font="${theme.fonts.nerd}:Bold:13.0" \
        label.color=${theme.colors.peach} \
        label.padding_left=3 \
        label.padding_right=6 \
        update_freq=5 \
        script="${updateGpu}" \
        click_script="${gpuDetail}; ${sbar} --set gpu popup.drawing=toggle"

    ${sbar} --add item gpu.header popup.gpu \
      --set gpu.header \
        icon="${theme.icons.gpu}  GPU" \
        icon.font="${theme.fonts.text}:Bold:13.0" \
        icon.color=${theme.colors.peach} \
        icon.padding_left=10 \
        icon.padding_right=10 \
        label.drawing=off

    ${mkRow { name = "gpu.util"; parent = "gpu"; width = 200; }}
    ${sbar} --set gpu.util icon="Utilization"
    ${mkRow { name = "gpu.model"; parent = "gpu"; width = 200; labelColor = theme.colors.white; }}
    ${sbar} --set gpu.model icon="Chip"
  '';

  init = "${gpuDetail}; ${updateGpu}";
}
