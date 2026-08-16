{ pkgs, lib, theme, sbar, ... }:
let
  aerospace = lib.getExe pkgs.aerospace;
  barMode = import ../helpers/bar-mode.nix { inherit pkgs lib; };
  maxIcons = theme.bar.maxWorkspaceIcons;
  maxRowIcons = theme.bar.maxRowAppIcons;

  # Padding an app icon has once it is revealed; collapsing animates all of
  # these (and the label width) down to zero so a hidden icon takes no space.
  iconLabelPadding = 5;
  iconItemPadding = 3;

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

    anim=(--animate ${theme.bar.appIconAnimationCurve} ${toString theme.bar.appIconAnimationFrames})

    # A revealed icon gets its natural (dynamic) label width back. A collapsed
    # one keeps drawing in the horizontal layout -- at zero width and zero
    # padding, so it is invisible and takes no room -- which is what lets the
    # transition animate instead of popping. The vertical layout has no icon
    # budget, so there unused slots are simply not drawn.
    shown=(drawing=on label.drawing=on label.width=dynamic
      label.padding_left=${toString iconLabelPadding}
      label.padding_right=${toString iconLabelPadding}
      background.padding_left=${toString iconItemPadding}
      background.padding_right=${toString iconItemPadding})

    if [ "$mode" = top ]; then
      hidden=(drawing=on label.drawing=on label.width=0
        label.padding_left=0 label.padding_right=0
        background.padding_left=0 background.padding_right=0)
    else
      hidden=(drawing=off label.drawing=off)
    fi

    # --- collect the windows of every workspace ----------------------------
    sids=()
    workspace_apps=()
    total=0

    for sid in $(${aerospace} list-workspaces --all); do
      apps=$(${aerospace} list-windows --workspace "$sid" --format '%{app-name}')

      count=0
      if [ -n "$apps" ]; then
        count=$(printf '%s\n' "$apps" | grep -c .)
        [ "$count" -gt ${toString maxIcons} ] && count=${toString maxIcons}
      fi

      sids+=("$sid")
      workspace_apps+=("$apps")
      total=$((total + count))
    done

    # Past the icon budget only the focused workspace keeps its icons, so the
    # strip can never grow wider than ${toString maxRowIcons} icons.
    collapse=0
    if [ "$mode" = top ] && [ "$total" -gt ${toString maxRowIcons} ]; then
      collapse=1
    fi

    # --- apply -------------------------------------------------------------
    for idx in "''${!sids[@]}"; do
      sid="''${sids[idx]}"
      apps="''${workspace_apps[idx]}"

      limit=${toString maxIcons}
      if [ "$collapse" = 1 ]; then
        if [ "$sid" = "$focused" ]; then
          limit=${toString maxRowIcons}
        else
          limit=0
        fi
      fi

      args=()
      i=1
      if [ -n "$apps" ]; then
        while IFS= read -r app; do
          [ "$i" -gt ${toString maxIcons} ] && break
          __icon_map "$app"
          # The label stays set on collapsed icons so reopening only has to
          # animate the width back out.
          if [ "$i" -le "$limit" ]; then
            args+=("''${anim[@]}" --set "space.$sid.icon.$i" label="$icon_result" "''${shown[@]}")
          else
            args+=("''${anim[@]}" --set "space.$sid.icon.$i" label="$icon_result" "''${hidden[@]}")
          fi
          i=$((i + 1))
        done <<< "$apps"
      fi

      while [ "$i" -le ${toString maxIcons} ]; do
        args+=("''${anim[@]}" --set "space.$sid.icon.$i" label="" "''${hidden[@]}")
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

      # App icons start collapsed (zero width, no padding) so the first update
      # animates them open. `scroll_texts` clips the glyph to the animated label
      # width instead of letting it spill over the neighbouring items.
      for i in $(seq 1 ${toString maxIcons}); do
        ${sbar} --add item space.$sid.icon.$i center \
          --subscribe "space.$sid" aerospace_workspace_change \
          --set space.$sid.icon.$i \
            icon.drawing=off \
            label.font="${theme.fonts.appIcons}:Regular:16.0" \
            label.color=${theme.colors.white} \
            label.width=0 \
            label.padding_left=0 \
            label.padding_right=0 \
            background.drawing=off \
            background.padding_left=0 \
            background.padding_right=0 \
            scroll_texts=on \
            drawing=on \
            click_script="${aerospace} workspace $sid"
      done
    done
  '';

  init = "${updateWorkspaceAppIcons}";
}
