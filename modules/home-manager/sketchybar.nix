{ pkgs, ... }:
let
  aerospaceItem = pkgs.writeShellScript "sketchybar-aerospace-item.sh" ''
    source ${pkgs.sketchybar-app-font}/bin/icon_map.sh

    sid="''${NAME#space.}"

    # $FOCUSED_WORKSPACE is only set for aerospace_workspace_change; fall back to
    # querying it (e.g. when this runs on front_app_switched).
    focused="$FOCUSED_WORKSPACE"
    if [ -z "$focused" ]; then
      focused="$(${pkgs.aerospace}/bin/aerospace list-workspaces --focused)"
    fi

    if [ "$focused" = "$sid" ]; then
      drawing=on
    else
      drawing=off
    fi

    # One icon per distinct app that has a window in this workspace.
    icons=""
    apps="$(${pkgs.aerospace}/bin/aerospace list-windows --workspace "$sid" --format '%{app-name}' | sort -u)"
    while IFS= read -r app; do
      [ -z "$app" ] && continue
      __icon_map "$app"
      icons="''${icons}''${icon_result}"
    done <<EOF
    $apps
    EOF

    sketchybar --set "$NAME" background.drawing="$drawing" label="$icons"
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
        padding_left=4 \
        padding_right=4

      # --- AeroSpace workspace indicators ---
      # Custom event AeroSpace triggers on workspace change (see aerospace.nix).
      # On a right-positioned bar, "left" means the top.
      sketchybar --add event aerospace_workspace_change

      for sid in $(aerospace list-workspaces --all); do
        sketchybar --add item space.$sid left \
          --subscribe space.$sid aerospace_workspace_change front_app_switched \
          --set space.$sid \
            icon="$sid" \
            icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
            icon.padding_left=6 \
            icon.padding_right=2 \
            label.font="sketchybar-app-font:Regular:16.0" \
            label.padding_left=2 \
            label.padding_right=6 \
            background.color=0x44ffffff \
            background.corner_radius=6 \
            background.height=26 \
            background.drawing=off \
            click_script="aerospace workspace $sid" \
            script="${aerospaceItem}"
      done

      # Populate icons + highlight the currently focused workspace (initial state).
      sketchybar --trigger aerospace_workspace_change \
        FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

      sketchybar --update
    '';
  };
}
