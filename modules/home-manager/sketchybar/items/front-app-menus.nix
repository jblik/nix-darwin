{ pkgs, theme, sbar, ... }:
let
  menusHelper = import ../helpers/menus.nix { inherit pkgs; };
  menus = "${menusHelper}/bin/menus";
  maxMenus = theme.bar.maxAppMenus;

  updateFrontAppMenus = pkgs.writeShellScript "sketchybar-front-app-menus.sh" ''
    ${sbar} --set '/menu\.[0-9]+/' drawing=off

    index=1
    ${menus} -l | while IFS= read -r title; do
      [ "$index" -gt ${toString maxMenus} ] && break
      ${sbar} --set "menu.$index" label="$title" drawing=on
      index=$((index + 1))
    done
  '';
in
{
  packages = [ menusHelper ];

  config = ''
    ${sbar} --add item menu_watcher left \
      --set menu_watcher drawing=off updates=on script="${updateFrontAppMenus}" \
      --subscribe menu_watcher front_app_switched

    for i in $(seq 1 ${toString maxMenus}); do
      if [ "$i" -eq 1 ]; then style=Heavy; else style=Semibold; fi
      ${sbar} --add item "menu.$i" left \
        --set "menu.$i" \
          drawing=off \
          icon.drawing=off \
          label.font="${theme.fonts.text}:$style:11.0" \
          label.padding_left=6 \
          label.padding_right=6 \
          click_script="${menus} -s $i"
    done
  '';

  init = "${updateFrontAppMenus}";
}
