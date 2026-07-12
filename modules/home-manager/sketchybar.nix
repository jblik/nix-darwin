{ pkgs, ... }:
let
  maxIcons = 10;

  # Runs once per aerospace event (not once per item) and applies every
  # highlight/label change in a single atomic `sketchybar --set` call, so a
  # workspace switch updates the whole bar at once instead of cascading
  # item-by-item.
  updateSpaces = pkgs.writeShellScript "sketchybar-update-spaces.sh" ''
    source ${pkgs.sketchybar-app-font}/bin/icon_map.sh

    max=${toString maxIcons}

    focused="$FOCUSED_WORKSPACE"
    if [ -z "$focused" ]; then
      focused="$(${pkgs.aerospace}/bin/aerospace list-workspaces --focused)"
    fi

    args=()
    for sid in $(${pkgs.aerospace}/bin/aerospace list-workspaces --all); do
      if [ "$focused" = "$sid" ]; then
        hl=on
      else
        hl=off
      fi
      args+=(--set "space.$sid" "background.drawing=$hl")

      apps="$(${pkgs.aerospace}/bin/aerospace list-windows --workspace "$sid" --format '%{app-name}' | sort -u)"
      i=1
      while IFS= read -r app; do
        [ -z "$app" ] && continue
        [ "$i" -gt "$max" ] && break
        __icon_map "$app"
        args+=(--set "space.$sid.icon.$i" "label=$icon_result" "drawing=on" "background.drawing=$hl")
        i=$((i + 1))
      done <<< "$apps"

      while [ "$i" -le "$max" ]; do
        args+=(--set "space.$sid.icon.$i" "drawing=off")
        i=$((i + 1))
      done
    done

    sketchybar "''${args[@]}"
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
      # Fixed width on every item so a workspace number and its app icons
      # highlight as identically-sized pills (no step between title/icon).
      sketchybar --default \
        icon.color=0xffffffff \
        label.color=0xffffffff \
        icon.align=center \
        label.align=center \
        width=30 \
        padding_left=4 \
        padding_right=4

      # --- AeroSpace workspace indicators ---
      # Custom event AeroSpace triggers on workspace change (see aerospace.nix).
      sketchybar --add event aerospace_workspace_change

      # Single invisible item that owns the updater script. Only one item
      # subscribes to the event so one script run updates every workspace's
      # highlight/icons together in one --set call, instead of each
      # workspace's item independently animating on its own.
      sketchybar --add item space_updater left \
        --subscribe space_updater aerospace_workspace_change front_app_switched \
        --set space_updater drawing=off width=0 padding_left=0 padding_right=0 \
        script="${updateSpaces}"

      for sid in $(aerospace list-workspaces --all); do
        # Workspace number (header).
        # On a right-positioned bar, "left" means the top, and items stack
        # downward in the order they're added: number first, then its
        # app-icon slots below. The focused workspace's items all share the
        # same background highlight.
        sketchybar --add item space.$sid left \
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
            click_script="aerospace workspace $sid"

        # App-icon slots stacked under the number (filled by the updater).
        # Same color/height/radius/width as the number above, with zero
        # padding, so a focused workspace's highlight reads as one
        # continuous bar rather than separate pills.
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

      # Populate icons + highlight the currently focused workspace (initial state).
      sketchybar --trigger aerospace_workspace_change \
        FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

      sketchybar --update
    '';
  };
}
