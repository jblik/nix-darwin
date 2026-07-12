{ pkgs, theme, sbar, ... }:
let
  sparkline = import ../helpers/sparkline.nix { inherit pkgs; };
  cache = "$HOME/.cache/sketchybar";

  updateGpu = pkgs.writeShellScript "sketchybar-gpu.sh" ''
    mkdir -p ${cache}
    used=$(ioreg -r -d 1 -w 0 -c IOAccelerator \
      | grep -o '"Device Utilization %"=[0-9]*' \
      | head -1 \
      | grep -o '[0-9]*$')
    used=''${used:-0}
    graph=$(${sparkline} "${cache}/gpu.hist" "$used" 7)
    ${sbar} --set gpu label="$graph"
  '';

  gpuDetail = pkgs.writeShellScript "sketchybar-gpu-detail.sh" ''
    used=$(ioreg -r -d 1 -w 0 -c IOAccelerator \
      | grep -o '"Device Utilization %"=[0-9]*' \
      | head -1 \
      | grep -o '[0-9]*$')
    name=$(ioreg -r -d 1 -w 0 -c IOAccelerator \
      | grep -o '"model"=<"[^"]*"' \
      | head -1 \
      | sed -E 's/.*<"//')
    ${sbar} --set gpu.util label="''${used:-0}%" \
            --set gpu.model label="''${name:-Apple GPU}"
  '';

  row = name: ''
    ${sbar} --add item ${name} popup.gpu \
      --set ${name} \
        width=200 \
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
    ${sbar} --add item gpu right \
      --set gpu \
        icon.drawing=off \
        label="▁▁▁▁▁▁▁" \
        label.font="${theme.fonts.nerd}:Bold:13.0" \
        label.color=${theme.colors.peach} \
        label.padding_left=6 \
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

    ${row "gpu.util"}
    ${sbar} --set gpu.util icon="Utilization"
    ${row "gpu.model"}
    ${sbar} --set gpu.model icon="Chip" label.color=${theme.colors.white}
  '';

  init = "${gpuDetail}; ${updateGpu}";
}
