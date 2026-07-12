{ pkgs, theme, sbar, ... }:
let
  updateGpu = pkgs.writeShellScript "sketchybar-gpu.sh" ''
    used=$(ioreg -r -d 1 -w 0 -c IOAccelerator \
      | grep -o '"Device Utilization %"=[0-9]*' \
      | head -1 \
      | grep -o '[0-9]*$')
    ${sbar} --set gpu label="''${used:-0}%"
  '';
in
{
  config = ''
    ${sbar} --add item gpu right \
      --set gpu \
        icon="${theme.icons.gpu}" \
        icon.font="${theme.fonts.nerd}:Bold:14.0" \
        icon.color=${theme.colors.peach} \
        icon.padding_left=6 \
        icon.padding_right=3 \
        label.font="${theme.fonts.text}:Semibold:11.0" \
        label.padding_left=0 \
        label.padding_right=6 \
        update_freq=5 \
        script="${updateGpu}"
  '';

  init = "${updateGpu}";
}
