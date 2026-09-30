{ pkgs, theme, sbar, ... }:
let
  updateRam = pkgs.writeShellScript "sketchybar-ram.sh" ''
    free=$(memory_pressure | awk -F': ' '/free percentage/ { gsub(/%/, "", $2); print $2 }')
    used=$((100 - free))
    ${sbar} --set ram label="''${used}%"
  '';
in
{
  config = ''
    ${sbar} --add item ram right \
      --set ram \
        icon="${theme.icons.ram}" \
        icon.font="${theme.fonts.nerd}:Bold:14.0" \
        icon.color=${theme.colors.blue} \
        icon.padding_left=6 \
        icon.padding_right=3 \
        label.font="${theme.fonts.text}:Semibold:11.0" \
        label.padding_left=0 \
        label.padding_right=6 \
        update_freq=5 \
        script="${updateRam}"
  '';

  init = "${updateRam}";
}
