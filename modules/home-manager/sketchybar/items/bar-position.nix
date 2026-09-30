{ pkgs, lib, theme, sbar, ... }:
let
  aerospace = lib.getExe pkgs.aerospace;
  barMode = import ../helpers/bar-mode.nix { inherit pkgs lib; };
  maxIcons = theme.bar.maxWorkspaceIcons;
  maxMenus = theme.bar.maxAppMenus;

  # SketchyBar's `position`/`height` are single global values, so a bar cannot
  # be oriented differently per display simultaneously. Instead we switch the
  # whole layout at runtime depending on which display is in use:
  #
  #   built-in laptop screen only ("top") -> flush horizontal menu bar; the
  #     status cluster lives on the right reading (right -> left) clock,
  #     battery, wifi, then the workspaces; the notch is reserved.
  #   external / docked ("left")          -> the normal floating vertical bar
  #     on the left with the workspaces centered.
  #
  # It fires on display_change / system_woke, and once at startup via init.
  repositionBar = pkgs.writeShellScript "sketchybar-bar-position.sh" ''
    mode=$(${barMode})
    sids=$(${aerospace} list-workspaces --all)

    # --- bar geometry -------------------------------------------------------
    if [ "$mode" = top ]; then
      ${sbar} --bar position=top height=${toString theme.bar.menuBarWidth} \
        y_offset=0 margin=0 corner_radius=0 notch_width=${toString theme.bar.notchWidth}
      align=right
      clockpos=right
      spacebg=${toString theme.bar.menuBarSpaceBackgroundHeight}
    else
      ${sbar} --bar position=left height=${toString theme.bar.width} \
        y_offset=10 margin=10 corner_radius=9
      align=center
      clockpos=left
      spacebg=${toString theme.bar.spaceBackgroundHeight}
    fi

    # --- item alignment + workspace number background size ------------------
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
    setargs+=(--set battery position=right)
    setargs+=(--set wifi position=right)
    ${sbar} "''${setargs[@]}"

    # --- draw order ---------------------------------------------------------
    # Right-anchored items draw from the right edge inward (first listed =
    # rightmost). The left/docked layout uses the natural left-to-right order.
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
        "''${spaces[@]}" battery wifi
    fi
  '';
in
{
  config = ''
    ${sbar} --add item bar_position_watcher left \
      --set bar_position_watcher drawing=off updates=on script="${repositionBar}" \
      --subscribe bar_position_watcher display_change system_woke
  '';

  init = "${repositionBar}";
}
