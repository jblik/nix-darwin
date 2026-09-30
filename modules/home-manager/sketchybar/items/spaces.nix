{ pkgs, lib, theme, sbar, ... }:
let
  aerospace = lib.getExe pkgs.aerospace;
  barMode = import ../helpers/bar-mode.nix { inherit pkgs lib; };
  maxIcons = theme.bar.maxWorkspaceIcons;

  highlightFocusedWorkspace = pkgs.writeShellScript "sketchybar-workspace-highlight.sh" ''
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      ${sbar} --set "$NAME" background.color=${theme.colors.selectedGray}
    else
      ${sbar} --set "$NAME" background.color=${theme.colors.black}
    fi
  '';

  updateWorkspaceAppIcons = pkgs.writeShellScript "sketchybar-workspace-apps.sh" ''
    source ${pkgs.sketchybar-app-font}/bin/icon_map.sh

    mode=$(${barMode})
    focused=$(${aerospace} list-workspaces --focused)

    for sid in $(${aerospace} list-workspaces --all); do
      apps=$(${aerospace} list-windows --workspace "$sid" --format '%{app-name}')

      args=()
      i=1
      if [ -n "$apps" ]; then
        while IFS= read -r app; do
          [ "$i" -gt ${toString maxIcons} ] && break
          __icon_map "$app"
          args+=(--set "space.$sid.icon.$i" label="$icon_result" label.drawing=on drawing=on)
          i=$((i + 1))
        done <<< "$apps"
      fi

      while [ "$i" -le ${toString maxIcons} ]; do
        args+=(--set "space.$sid.icon.$i" drawing=off label.drawing=off)
        i=$((i + 1))
      done

      # In the top/menu-bar layout hide workspaces that hold no windows
      # (but always keep the focused one visible).
      if [ "$mode" = top ] && [ -z "$apps" ] && [ "$sid" != "$focused" ]; then
        args+=(--set "space.$sid" drawing=off)
      else
        args+=(--set "space.$sid" drawing=on)
      fi

      ${sbar} "''${args[@]}"
    done
  '';
in
{
  packages = [ pkgs.sketchybar-app-font ];

  config = ''
    ${sbar} --add event aerospace_workspace_change

    ${sbar} --add item apps_updater center \
      --set apps_updater drawing=off updates=on script="${updateWorkspaceAppIcons}" \
      --subscribe apps_updater aerospace_workspace_change front_app_switched display_change system_woke

    for sid in $(${aerospace} list-workspaces --all); do
      ${sbar} --add item "space.$sid" center \
        --subscribe "space.$sid" aerospace_workspace_change \
        --set "space.$sid" \
          icon="$sid" \
          icon.font="${theme.fonts.text}:Bold:11.0" \
          icon.padding_left=22 \
          icon.padding_right=22 \
          label.padding_right=33 \
          icon.highlight_color=${theme.colors.red} \
          background.color=${theme.colors.black} \
          background.corner_radius=5 \
          background.height=${toString theme.bar.spaceBackgroundHeight} \
          background.drawing=on \
          label.font="${theme.fonts.appIcons}:Regular:16.0" \
          label.background.height=30 \
          label.background.drawing=on \
          label.background.color=${theme.colors.itemBackground} \
          label.background.corner_radius=9 \
          label.drawing=off \
          click_script="${aerospace} workspace $sid" \
          script="${highlightFocusedWorkspace} $sid"

      for i in $(seq 1 ${toString maxIcons}); do
        ${sbar} --add item space.$sid.icon.$i center \
          --subscribe "space.$sid" aerospace_workspace_change \
          --set space.$sid.icon.$i \
            icon.drawing=off \
            label.font="${theme.fonts.appIcons}:Regular:16.0" \
            label.color=${theme.colors.white} \
            label.padding_left=5 \
            label.padding_right=5 \
            background.drawing=off \
            drawing=off \
            click_script="${aerospace} workspace $sid"
      done
    done
  '';

  init = "${updateWorkspaceAppIcons}";
}
