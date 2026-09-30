{ pkgs, lib, ... }:
let
  refreshIcons = "exec-and-forget ${lib.getExe pkgs.sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(${lib.getExe pkgs.aerospace} list-workspaces --focused)";
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      after-startup-command = [ "exec-and-forget ${lib.getExe pkgs.sketchybar} --reload" ];

      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${lib.getExe pkgs.sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      # Refresh the workspace app icons when a window opens, so a newly opened
      # app appears without a workspace switch.
      on-window-detected = [
        { run = refreshIcons; }
      ];

      key-mapping.preset = "qwerty";

      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = [
          { monitor."built-in" = 10; }
          70
        ];
        outer.right = 10;
        outer.top = 10;
        outer.bottom = 10;
      };

      mode.main.binding = {
        # Layout.
        "alt-slash" = "layout tiles horizontal vertical";
        "alt-comma" = "layout accordion horizontal vertical";

        # Focus.
        "alt-h" = "focus left";
        "alt-j" = "focus down";
        "alt-k" = "focus up";
        "alt-l" = "focus right";

        # Move.
        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";

        # Resize.
        "alt-minus" = "resize smart -50";
        "alt-equal" = "resize smart +50";
        "alt-shift-minus" = "resize smart -150";
        "alt-shift-equal" = "resize smart +150";

        # Switch to workspace.
        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-5" = "workspace 5";

        # Move focused window to workspace (and refresh the app icons, since
        # AeroSpace emits no event for moving a node between workspaces).
        "alt-shift-1" = [
          "move-node-to-workspace 1"
          refreshIcons
        ];
        "alt-shift-2" = [
          "move-node-to-workspace 2"
          refreshIcons
        ];
        "alt-shift-3" = [
          "move-node-to-workspace 3"
          refreshIcons
        ];
        "alt-shift-4" = [
          "move-node-to-workspace 4"
          refreshIcons
        ];
        "alt-shift-5" = [
          "move-node-to-workspace 5"
          refreshIcons
        ];

        # Workspace navigation and service mode.
        "alt-tab" = "workspace-back-and-forth";
        "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
        "alt-shift-semicolon" = "mode service";
      };

      mode.service.binding = {
        "esc" = [
          "reload-config"
          "mode main"
        ];
        "r" = [
          "flatten-workspace-tree"
          "mode main"
        ];
        "f" = [
          "layout floating tiling"
          "mode main"
        ];
        "shift-w" = [
          "close-all-windows-but-current"
          "mode main"
        ];
        "alt-shift-h" = [
          "join-with left"
          "mode main"
        ];
        "alt-shift-j" = [
          "join-with down"
          "mode main"
        ];
        "alt-shift-k" = [
          "join-with up"
          "mode main"
        ];
        "alt-shift-l" = [
          "join-with right"
          "mode main"
        ];
      };
    };
  };
}
