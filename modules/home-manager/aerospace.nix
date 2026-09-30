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

      key-mapping.preset = "qwerty";

      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.right = 8;
        outer.top = 8;
        outer.bottom = 8;
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

        # Switch to workspace.
        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-5" = "workspace 5";

        # Move focused window to workspace.
        "alt-shift-1" = "move-node-to-workspace 1";
        "alt-shift-2" = "move-node-to-workspace 2";
        "alt-shift-3" = "move-node-to-workspace 3";
        "alt-shift-4" = "move-node-to-workspace 4";
        "alt-shift-5" = "move-node-to-workspace 5";

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
        "backspace" = [
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
