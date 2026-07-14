{ pkgs, lib, sbar, ... }:
let
  aerospace = lib.getExe pkgs.aerospace;

  repositionBar = pkgs.writeShellScript "sketchybar-bar-position.sh" ''
    monitors=$(${aerospace} list-monitors --format '%{monitor-name}')
    count=$(printf '%s\n' "$monitors" | grep -c .)

    if [ "$count" -eq 1 ] && printf '%s\n' "$monitors" | grep -qiE 'built[ -]?in'; then
      ${sbar} --bar position=top
    else
      ${sbar} --bar position=left
    fi
  '';
in
{
  config = ''
    ${sbar} --add item bar_position_watcher left \
      --set bar_position_watcher drawing=off updates=on script="${repositionBar}" \
      --subscribe bar_position_watcher display_change system_woke
  '';

  init = "${repositionBar}";
}
