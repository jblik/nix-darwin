{ pkgs, lib, theme, sbar, ... }:
let
  menusHelper = import ../helpers/menus.nix { inherit pkgs; };
  menus = "${menusHelper}/bin/menus";
  barMode = import ../helpers/bar-mode.nix { inherit pkgs lib; };
  maxMenus = theme.bar.maxAppMenus;

  updateFrontAppMenus = pkgs.writeShellScript "sketchybar-front-app-menus.sh" ''
    source ${pkgs.sketchybar-app-font}/bin/icon_map.sh

    mapfile -t titles < <(${menus} -l)

    # In the top/menu-bar layout keep the first `menusLeftOfNotch` items to the
    # left of the notch and overflow the rest to the right of it ("e"); in the
    # docked layout every menu stays on the left.
    if [ "$(${barMode})" = top ]; then
      leftcount=${toString theme.bar.menusLeftOfNotch}
    else
      leftcount=${toString maxMenus}
    fi

    args=()
    index=1
    for title in "''${titles[@]}"; do
      [ "$index" -gt ${toString maxMenus} ] && break
      if [ "$index" -le "$leftcount" ]; then pos=left; else pos=e; fi
      if [ "$index" -eq 1 ]; then
        __icon_map "$title"
        args+=(--set "menu.$index" label="$icon_result" drawing=on position="$pos")
      else
        args+=(--set "menu.$index" label="$title" drawing=on position="$pos")
      fi
      index=$((index + 1))
    done

    while [ "$index" -le ${toString maxMenus} ]; do
      args+=(--set "menu.$index" drawing=off)
      index=$((index + 1))
    done

    ${sbar} "''${args[@]}"
  '';
in
{
  packages = [ menusHelper pkgs.sketchybar-app-font ];

  config = ''
    ${sbar} --add item menu_watcher left \
      --set menu_watcher drawing=off updates=on script="${updateFrontAppMenus}" \
      --subscribe menu_watcher front_app_switched display_change system_woke

    for i in $(seq 1 ${toString maxMenus}); do
      if [ "$i" -eq 1 ]; then
        ${sbar} --add item "menu.$i" left \
          --set "menu.$i" \
            drawing=off \
            icon.drawing=off \
            label.font="${theme.fonts.appIcons}:Regular:16.0" \
            label.padding_left=6 \
            label.padding_right=6 \
            click_script="${menus} -s $i"
      else
        ${sbar} --add item "menu.$i" left \
          --set "menu.$i" \
            drawing=off \
            icon.drawing=off \
            label.font="${theme.fonts.text}:Semibold:11.0" \
            label.padding_left=6 \
            label.padding_right=6 \
            click_script="${menus} -s $i"
      fi
    done
  '';

  init = "${updateFrontAppMenus}";
}
