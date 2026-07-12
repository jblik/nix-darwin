{ pkgs, theme, sbar, ... }:
let
  updateClock = pkgs.writeShellScript "sketchybar-clock.sh" ''
    ${sbar} --set clock.time label="$(date '+%H:%M')" \
            --set clock.date label="$(date '+%a %d %b')"
  '';
in
{
  config = ''
    ${sbar} --add item clock.time left \
      --set clock.time \
        icon.drawing=off \
        label.font="${theme.fonts.text}:Bold:15.0" \
        label.align=center \
        label.padding_left=4 \
        label.padding_right=4 \
        update_freq=15 \
        script="${updateClock}" \
      --subscribe clock.time system_woke \
      --add item clock.date left \
      --set clock.date \
        icon.drawing=off \
        label.font="${theme.fonts.text}:Semibold:10.0" \
        label.color=${theme.colors.lavender} \
        label.align=center \
        label.padding_left=4 \
        label.padding_right=4 \
        background.padding_bottom=10
  '';

  init = "${updateClock}";
}
