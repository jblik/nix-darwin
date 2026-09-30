{ pkgs, ... }:
let
  maxIcons = 10;

  aerospaceItem = pkgs.writeShellScript "sketchybar-aerospace-item.sh" ''
    source ${pkgs.sketchybar-app-font}/bin/icon_map.sh

    sid="''${NAME#space.}"
    max=${toString maxIcons}

    focused="$FOCUSED_WORKSPACE"
    if [ -z "$focused" ]; then
      focused="$(${pkgs.aerospace}/bin/aerospace list-workspaces --focused)"
    fi

    if [ "$focused" = "$sid" ]; then
      hl=on
    else
      hl=off
    fi
    sketchybar --set "$NAME" background.drawing="$hl"

    apps="$(${pkgs.aerospace}/bin/aerospace list-windows --workspace "$sid" --format '%{app-name}' | sort -u)"
    i=1
    while IFS= read -r app; do
      [ -z "$app" ] && continue
      [ "$i" -gt "$max" ] && break
      __icon_map "$app"
      sketchybar --set "space.$sid.icon.$i" label="$icon_result" drawing=on background.drawing="$hl"
      i=$((i + 1))
    done <<EOF
    $apps
    EOF

    while [ "$i" -le "$max" ]; do
      sketchybar --set "space.$sid.icon.$i" drawing=off
      i=$((i + 1))
    done
  '';
in
{
  home.packages = [ pkgs.sketchybar-app-font ];

  programs.sketchybar = {
    enable = true;
    configType = "bash";

    extraPackages = [ pkgs.aerospace ];

    config = ''
      sketchybar --bar \
        position=right \
        height=40 \
        color=0xff1e1e2e \
        sticky=on \
        padding_left=6 \
        padding_right=6

      sketchybar --default \
        icon.color=0xffffffff \
        label.color=0xffffffff \
        icon.align=center \
        label.align=center \
        padding_left=4 \
        padding_right=4

      sketchybar --add event aerospace_workspace_change

      for sid in $(aerospace list-workspaces --all); do
        # Workspace number (header). Only this item runs the updater script.
        sketchybar --add item space.$sid left \
          --subscribe space.$sid aerospace_workspace_change front_app_switched \
          --set space.$sid \
            icon="$sid" \
            icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
            label.drawing=off \
            padding_left=14 \
            padding_right=0 \
            background.color=0xff45475a \
            background.corner_radius=0 \
            background.height=30 \
            background.drawing=off \
            click_script="aerospace workspace $sid" \
            script="${aerospaceItem}"

        for i in $(seq 1 ${toString maxIcons}); do
          sketchybar --add item space.$sid.icon.$i left \
            --set space.$sid.icon.$i \
              icon.drawing=off \
              label.font="sketchybar-app-font:Regular:16.0" \
              padding_left=0 \
              padding_right=0 \
              background.color=0xff45475a \
              background.corner_radius=0 \
              background.height=30 \
              background.drawing=off \
              drawing=off \
              click_script="aerospace workspace $sid"
        done
      done

      sketchybar --trigger aerospace_workspace_change \
        FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

      sketchybar --update
    '';
  };
}
