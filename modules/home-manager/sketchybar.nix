{ pkgs, ... }:
let
  maxIcons = 8;

  aerospaceItem = pkgs.writeShellScript "sketchybar-aerospace-item.sh" ''
    source ${pkgs.sketchybar-app-font}/bin/icon_map.sh

    sid="''${NAME#space.}"
    max=${toString maxIcons}

    # $FOCUSED_WORKSPACE is only set for aerospace_workspace_change; fall back to
    # querying it (e.g. when this runs on front_app_switched).
    focused="$FOCUSED_WORKSPACE"
    if [ -z "$focused" ]; then
      focused="$(${pkgs.aerospace}/bin/aerospace list-workspaces --focused)"
    fi

    if [ "$focused" = "$sid" ]; then
      sketchybar --set "$NAME" background.drawing=on
    else
      sketchybar --set "$NAME" background.drawing=off
    fi

    # One glyph per distinct app that has a window in this workspace, each in its
    # own slot item so they stack vertically under the number.
    apps="$(${pkgs.aerospace}/bin/aerospace list-windows --workspace "$sid" --format '%{app-name}' | sort -u)"
    i=1
    while IFS= read -r app; do
      [ -z "$app" ] && continue
      [ "$i" -gt "$max" ] && break
      __icon_map "$app"
      sketchybar --set "space.$sid.icon.$i" label="$icon_result" drawing=on
      i=$((i + 1))
    done <<EOF
    $apps
    EOF

    # Hide unused slots.
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
      # --- Vertical bar on the right edge of the screen ---
      sketchybar --bar \
        position=right \
        height=40 \
        color=0xff1e1e2e \
        sticky=on \
        padding_left=6 \
        padding_right=6

      # --- Item defaults ---
      sketchybar --default \
        icon.color=0xffffffff \
        label.color=0xffffffff \
        icon.align=center \
        label.align=center \
        padding_left=4 \
        padding_right=4

      # --- AeroSpace workspace indicators ---
      # Custom event AeroSpace triggers on workspace change (see aerospace.nix).
      # On a right-positioned bar, "left" means the top, and items stack downward
      # in the order they're added: number first, then its app-icon slots below.
      sketchybar --add event aerospace_workspace_change

      for sid in $(aerospace list-workspaces --all); do
        # Workspace number (header). Only this item runs the updater script.
        sketchybar --add item space.$sid left \
          --subscribe space.$sid aerospace_workspace_change front_app_switched \
          --set space.$sid \
            icon="$sid" \
            icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
            label.drawing=off \
            background.color=0x44ffffff \
            background.corner_radius=6 \
            background.height=26 \
            background.drawing=off \
            click_script="aerospace workspace $sid" \
            script="${aerospaceItem}"

        # App-icon slots stacked under the number (filled by the updater).
        for i in $(seq 1 ${toString maxIcons}); do
          sketchybar --add item space.$sid.icon.$i left \
            --set space.$sid.icon.$i \
              icon.drawing=off \
              label.font="sketchybar-app-font:Regular:16.0" \
              drawing=off \
              click_script="aerospace workspace $sid"
        done
      done

      # Populate icons + highlight the currently focused workspace (initial state).
      sketchybar --trigger aerospace_workspace_change \
        FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

      sketchybar --update
    '';
  };
}
