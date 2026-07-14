{ pkgs, lib, theme, sbar, ... }:
let
  aerospace = lib.getExe pkgs.aerospace;
  barMode = import ../helpers/bar-mode.nix { inherit pkgs lib; };
  maxIcons = theme.bar.maxWorkspaceIcons;
  maxMenus = theme.bar.maxAppMenus;

  # SketchyBar's `position`/`height` are single global values, so a bar cannot
  # be oriented differently per display simultaneously. This script instead
  # switches the whole layout at runtime depending on which display is in use:
  #
  #   built-in laptop screen only ("top") -> flush horizontal menu bar; the
  #     status cluster lives on the right reading (right -> left) clock,
  #     battery, wifi, then the workspaces; the notch is reserved; the CPU/
  #     RAM/GPU meters are hidden.
  #   external / docked ("left")          -> floating vertical bar on the left;
  #     workspaces centered; status icons and CPU/RAM/GPU meters stacked at the
  #     bottom (centered across the bar's width).
  #
  # It fires on display_change / system_woke, and once at startup via init.
  applyLayout = pkgs.writeShellScript "sketchybar-layout.sh" ''
    mode=$(${barMode})
    sids=$(${aerospace} list-workspaces --all)

    # --- bar geometry + per-mode variables ---------------------------------
    if [ "$mode" = top ]; then
      ${sbar} --bar position=top height=${toString theme.bar.menuBarWidth} \
        y_offset=0 margin=0 corner_radius=0 notch_width=${toString theme.bar.notchWidth}
      align=right
      clockpos=right
      spacebg=${toString theme.bar.menuBarSpaceBackgroundHeight}
      metricdraw=off
      statuspad_l=0                            # asymmetric: gap only on the right
      popupoff=${toString theme.bar.popupYOffsetTop}
      metricpopupoff=${toString theme.bar.popupYOffsetTop}
    else
      ${sbar} --bar position=left height=${toString theme.bar.width} \
        y_offset=10 margin=10 corner_radius=9
      align=center
      clockpos=left
      spacebg=${toString theme.bar.spaceBackgroundHeight}
      metricdraw=on
      statuspad_l=15                           # balanced with the 15pt right pad
      popupoff=${toString theme.bar.popupYOffsetLeft}
      metricpopupoff=${toString theme.bar.popupYOffsetMetricsLeft}
    fi

    # --- item alignment ----------------------------------------------------
    setargs=()
    spaces=()
    for sid in $sids; do
      setargs+=(--set "space.$sid" position="$align" background.height="$spacebg")
      spaces+=("space.$sid")
      for i in $(seq 1 ${toString maxIcons}); do
        setargs+=(--set "space.$sid.icon.$i" position="$align")
        spaces+=("space.$sid.icon.$i")
      done
    done

    setargs+=(--set clock.time position="$clockpos")
    setargs+=(--set clock.date position="$clockpos")

    # Status icons: right-anchored; balanced padding centers them vertically.
    for it in battery wifi; do
      setargs+=(--set "$it" position=right icon.align=center \
        background.padding_left="$statuspad_l")
    done

    # CPU/RAM/GPU meters: docked layout only, centered across the bar width.
    for it in cpu ram gpu; do
      setargs+=(--set "$it" position=right drawing="$metricdraw" icon.align=center \
        background.padding_left=6 background.padding_right=6)
    done

    # Detail popups need no vertical offset on top; the docked values are
    # tunable. The bottom-most CPU/RAM/GPU popups get a larger upward push.
    for it in battery wifi; do
      setargs+=(--set "$it" popup.y_offset="$popupoff")
    done
    for it in cpu ram gpu; do
      setargs+=(--set "$it" popup.y_offset="$metricpopupoff")
    done

    ${sbar} "''${setargs[@]}"

    # --- draw order --------------------------------------------------------
    # Right-anchored items draw from the right edge inward (first listed =
    # rightmost). The docked layout uses the natural left-to-right order.
    menus=()
    for i in $(seq 1 ${toString maxMenus}); do menus+=("menu.$i"); done

    if [ "$mode" = top ]; then
      revspaces=()
      for (( idx=''${#spaces[@]}-1 ; idx>=0 ; idx-- )); do
        revspaces+=("''${spaces[idx]}")
      done
      ${sbar} --reorder apple.logo "''${menus[@]}" \
        clock.date clock.time battery wifi "''${revspaces[@]}"
    else
      ${sbar} --reorder apple.logo clock.time clock.date "''${menus[@]}" \
        "''${spaces[@]}" battery wifi cpu ram gpu
    fi
  '';
in
{
  config = ''
    ${sbar} --add item layout_watcher left \
      --set layout_watcher drawing=off updates=on script="${applyLayout}" \
      --subscribe layout_watcher display_change system_woke
  '';

  init = "${applyLayout}";
}
