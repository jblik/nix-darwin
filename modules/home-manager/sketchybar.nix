{ pkgs, ... }:
{
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
        icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
        label.font="JetBrainsMono Nerd Font:Bold:14.0" \
        icon.color=0xffffffff \
        label.color=0xffffffff \
        padding_left=4 \
        padding_right=4

      # --- AeroSpace workspace indicators ---
      # Custom event that AeroSpace triggers on every workspace change
      # (see exec-on-workspace-change in aerospace.nix). On a right-positioned
      # bar, "left" means the top, so workspaces stack from the top down.
      sketchybar --add event aerospace_workspace_change

      for sid in $(aerospace list-workspaces --all); do
        sketchybar --add item space.$sid left \
          --subscribe space.$sid aerospace_workspace_change \
          --set space.$sid \
            label="$sid" \
            label.padding_left=8 \
            label.padding_right=8 \
            background.color=0x44ffffff \
            background.corner_radius=6 \
            background.height=26 \
            background.drawing=off \
            click_script="aerospace workspace $sid" \
            script="if [ \"\$FOCUSED_WORKSPACE\" = \"$sid\" ]; then sketchybar --set \$NAME background.drawing=on; else sketchybar --set \$NAME background.drawing=off; fi"
      done

      # Highlight whichever workspace is focused right now (initial state).
      sketchybar --trigger aerospace_workspace_change \
        FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

      sketchybar --update
    '';
  };
}
