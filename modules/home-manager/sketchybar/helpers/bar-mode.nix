{ pkgs, lib }:
let
  aerospace = lib.getExe pkgs.aerospace;
in
# Prints the current bar layout mode on stdout:
#   top  -> only the built-in laptop display is connected (menu-bar layout)
#   left -> an external display is present (normal docked layout)
# Shared by the reposition, spaces and front-app-menu scripts so they all
# agree on the mode without a separate state file.
pkgs.writeShellScript "sketchybar-bar-mode.sh" ''
  monitors=$(${aerospace} list-monitors --format '%{monitor-name}')
  count=$(printf '%s\n' "$monitors" | grep -c .)
  if [ "$count" -eq 1 ] && printf '%s\n' "$monitors" | grep -qiE 'built[ -]?in'; then
    echo top
  else
    echo left
  fi
''
