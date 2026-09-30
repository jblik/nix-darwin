{
  pkgs,
  lib,
  theme,
  sbar,
  ...
}:
let
  aerospace = lib.getExe pkgs.aerospace;
  barMode = import ../helpers/bar-mode.nix { inherit pkgs lib; };
  maxIcons = theme.bar.maxWorkspaceIcons;
  maxRowIcons = theme.bar.maxRowAppIcons;

  spaceSize = toString theme.bar.spaceBackgroundHeight;

  # Padding an app icon has once it is revealed; collapsing animates all of
  # these (and the icon/count widths) down to zero so a hidden icon takes no
  # space.
  iconPadding = 3;
  iconItemPadding = 3;
  countWidth = 10;
  verticalIconHeight = 24;

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

    # A revealed icon gets its natural (dynamic) width back. A collapsed
    # one keeps drawing in the horizontal layout -- at zero width and zero
    # padding, so it is invisible and takes no room -- which is what lets the
    # transition animate instead of popping. The vertical layout has no icon
    # budget, so there unused slots are simply not drawn.
    shown=(drawing=on icon.width=dynamic
      icon.padding_right=${toString iconPadding}
      background.padding_left=${toString iconItemPadding}
      background.padding_right=${toString iconItemPadding})

    if [ "$mode" = top ]; then
      shown+=(label.width=dynamic icon.padding_left=${toString iconPadding})
      hidden=(drawing=on icon.width=0 label.width=0
        icon.padding_left=0 icon.padding_right=0
        background.padding_left=0 background.padding_right=0)
    else
      # The vertical bar centers the whole item, so the count footer gets a
      # fixed width mirrored as padding left of the glyph to keep the glyph
      # itself centered. A slot there is only as tall as the glyph, which would
      # clip the lowered footer; an invisible taller background makes room.
      shown+=(label.width=${toString countWidth}
        icon.padding_left=${toString (iconPadding + countWidth)}
        background.drawing=on background.color=0x00000000
        background.height=${toString verticalIconHeight})
      hidden=(drawing=off)
    fi

    # --- collect the unique apps of every workspace ------------------------
    sids=()
    workspace_apps=()
    total=0

    for sid in $(${aerospace} list-workspaces --all); do
      # One "<window count><TAB><app>" line per app, in first-seen order.
      apps=$(${aerospace} list-windows --workspace "$sid" --format '%{app-name}' \
        | awk '!n[$0]++ { order[++k] = $0 } END { for (i = 1; i <= k; i++) print n[order[i]] "\t" order[i] }')

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
        while IFS=$'\t' read -r windows app; do
          [ "$i" -gt ${toString maxIcons} ] && break
          __icon_map "$app"
          badge=""
          [ "$windows" -gt 1 ] && badge="$windows"
          # The glyph stays set on collapsed icons so reopening only has to
          # animate the width back out.
          if [ "$i" -le "$limit" ]; then
            args+=("''${anim[@]}" --set "space.$sid.icon.$i" icon="$icon_result" label="$badge" "''${shown[@]}")
          else
            args+=("''${anim[@]}" --set "space.$sid.icon.$i" icon="$icon_result" label="$badge" "''${hidden[@]}")
          fi
          i=$((i + 1))
        done <<< "$apps"
      fi

      while [ "$i" -le ${toString maxIcons} ]; do
        args+=("''${anim[@]}" --set "space.$sid.icon.$i" icon="" label="" "''${hidden[@]}")
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
          icon.font="${theme.fonts.text}:Bold:10.0" \
          icon.width=${spaceSize} \
          icon.align=center \
          icon.padding_left=0 \
          icon.padding_right=0 \
          icon.highlight_color=${theme.colors.red} \
          background.color=${theme.colors.black} \
          background.corner_radius=5 \
          background.height=${spaceSize} \
          background.drawing=on \
          label.drawing=off \
          click_script="${aerospace} workspace $sid" \
          script="${highlightFocusedWorkspace} $sid"

      # App icons start collapsed (zero width, no padding) so the first update
      # animates them open. `scroll_texts` clips the glyph to the animated
      # width instead of letting it spill over the neighbouring items. The
      # label is the small window-count footer shown for duplicate windows.
      for i in $(seq 1 ${toString maxIcons}); do
        ${sbar} --add item space.$sid.icon.$i center \
          --subscribe "space.$sid" aerospace_workspace_change \
          --set space.$sid.icon.$i \
            icon.font="${theme.fonts.appIcons}:Regular:16.0" \
            icon.color=${theme.colors.white} \
            icon.width=0 \
            icon.padding_left=0 \
            icon.padding_right=0 \
            label.font="${theme.fonts.text}:Bold:8.0" \
            label.color=${theme.colors.lavender} \
            label.y_offset=-7 \
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
