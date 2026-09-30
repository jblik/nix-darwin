{ pkgs, lib, ... }:
let
  # Colors (sketchybar/colors.sh)
  BLACK = "0xff181926";
  WHITE = "0xffcad3f5";
  RED = "0xffed8796";
  GREEN = "0xffa6da95";
  BAR_COLOR = "0xcc24273a";

  # Icons (sketchybar/icons.sh)
  ICON_APPLE = "􀣺";
  ICON_PREFERENCES = "􀺽";
  ICON_ACTIVITY = "􀒓";
  ICON_LOCK = "􀒳";

  FONT = "SF Pro";

  POPUP_OFF = "sketchybar --set apple.logo popup.drawing=off";
  POPUP_CLICK_SCRIPT = "sketchybar --set \\$NAME popup.drawing=toggle";

  # Runs on aerospace_workspace_change for a single workspace item, toggling
  # its highlight background depending on whether it's the focused space.
  # (sketchybar/plugins/aerospacer.sh)
  aerospacer = pkgs.writeShellScript "sketchybar-aerospacer.sh" ''
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      ${lib.getExe pkgs.sketchybar} --set "$NAME" background.drawing=on
    else
      ${lib.getExe pkgs.sketchybar} --set "$NAME" background.drawing=off
    fi
  '';
in
{
  home.packages = [
    pkgs.sketchybar-app-font
    pkgs.nerd-fonts.hack
  ];

  programs.sketchybar = {
    enable = true;
    configType = "bash";

    extraPackages = [ pkgs.aerospace ];

    config = ''
      # --- Bar appearance (sketchybar/sketchybarrc) ---
      ${lib.getExe pkgs.sketchybar} --bar \
        height=50 \
        color=${BAR_COLOR} \
        shadow=on \
        position=right \
        sticky=on \
        padding_right=18 \
        padding_left=18 \
        corner_radius=9 \
        y_offset=10 \
        margin=10 \
        blur_radius=20

      ${lib.getExe pkgs.sketchybar} --default \
        updates=when_shown \
        icon.font="${FONT}:Bold:14.0" \
        icon.color=${WHITE} \
        icon.padding_left=3 \
        icon.padding_right=3 \
        label.font="${FONT}:Semibold:13.0" \
        label.color=${WHITE} \
        label.padding_left=3 \
        label.padding_right=3 \
        background.padding_right=3 \
        background.padding_left=3 \
        popup.background.border_width=2 \
        popup.background.corner_radius=11 \
        popup.background.border_color=${WHITE} \
        popup.background.color=${BLACK} \
        popup.background.shadow.drawing=on

      # --- Apple logo + popup menu (sketchybar/items/apple.sh) ---
      ${lib.getExe pkgs.sketchybar} --add item apple.logo left \
        --set apple.logo \
          icon="${ICON_APPLE}" \
          icon.font="${FONT}:Black:16.0" \
          icon.color=${GREEN} \
          background.padding_right=15 \
          label.drawing=off \
          click_script="${POPUP_CLICK_SCRIPT}" \
        --add item apple.prefs popup.apple.logo \
        --set apple.prefs \
          icon="${ICON_PREFERENCES}" \
          label="Preferences" \
          click_script="open -a 'System Settings'; ${POPUP_OFF}" \
        --add item apple.activity popup.apple.logo \
        --set apple.activity \
          icon="${ICON_ACTIVITY}" \
          label="Activity" \
          click_script="open -a 'Activity Monitor'; ${POPUP_OFF}" \
        --add item apple.lock popup.apple.logo \
        --set apple.lock \
          icon="${ICON_LOCK}" \
          label="Lock Screen" \
          click_script="pmset displaysleepnow; ${POPUP_OFF}"

      # --- AeroSpace workspace indicators + separator (sketchybar/items/spaces.sh) ---
      ${lib.getExe pkgs.sketchybar} --add event aerospace_workspace_change

      for sid in $(${lib.getExe pkgs.aerospace} list-workspaces --all); do
        ${lib.getExe pkgs.sketchybar} --add item "space.$sid" left \
          --subscribe "space.$sid" aerospace_workspace_change \
          --set "space.$sid" \
            icon="$sid" \
            icon.padding_left=22 \
            icon.padding_right=22 \
            label.padding_right=33 \
            icon.highlight_color=${RED} \
            background.color=0x44ffffff \
            background.corner_radius=5 \
            background.height=30 \
            background.drawing=off \
            label.font="sketchybar-app-font:Regular:16.0" \
            label.background.height=30 \
            label.background.drawing=on \
            label.background.color=0xff494d64 \
            label.background.corner_radius=9 \
            label.drawing=off \
            click_script="${lib.getExe pkgs.aerospace} workspace $sid" \
            script="${aerospacer} $sid"
      done

      ${lib.getExe pkgs.sketchybar} --add item separator left \
        --set separator \
          icon="" \
          icon.font="Hack Nerd Font:Regular:16.0" \
          background.padding_left=15 \
          background.padding_right=15 \
          label.drawing=off \
          associated_display=active \
          icon.color=${WHITE}

      # --- Calendar badge (sketchybar/items/calendar.sh) ---
      # Upstream ships this with icon.drawing=off and no label script, so it
      # renders as an empty pill; kept as-is for fidelity to the source repo.
      ${lib.getExe pkgs.sketchybar} --add item calendar right \
        --set calendar \
          icon=cal \
          icon.color=${BLACK} \
          icon.font="${FONT}:Black:12.0" \
          icon.padding_left=5 \
          icon.padding_right=5 \
          icon.drawing=off \
          label.color=${BLACK} \
          label.padding_left=5 \
          label.padding_right=5 \
          background.color=0xffb8c0e0 \
          background.height=26 \
          background.corner_radius=11

      ${lib.getExe pkgs.sketchybar} --update
    '';
  };
}
