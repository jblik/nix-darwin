{ pkgs, theme, sbar, ... }:
let
  updateCpu = pkgs.writeShellScript "sketchybar-cpu.sh" ''
    idle=$(top -l 2 -n 0 -s 1 | awk '/CPU usage/ { gsub(/%/, "", $7); value = $7 } END { print value }')
    used=$(awk "BEGIN { printf \"%.0f\", 100 - $idle }")
    ${sbar} --set cpu label="''${used}%"
  '';
in
{
  config = ''
    ${sbar} --add item cpu right \
      --set cpu \
        icon="${theme.icons.cpu}" \
        icon.font="${theme.fonts.nerd}:Bold:14.0" \
        icon.color=${theme.colors.green} \
        icon.padding_left=6 \
        icon.padding_right=3 \
        label.font="${theme.fonts.text}:Semibold:11.0" \
        label.padding_left=0 \
        label.padding_right=6 \
        update_freq=5 \
        script="${updateCpu}"
  '';

  init = "${updateCpu}";
}
