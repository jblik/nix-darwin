{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.right = 8;
        outer.top = 8;
        outer.bottom = 8;
      };

      # mode.main.binding = {
      #   alt-slash = "layout tiles horizontal vertical";
      #   alt-comma = "layout accordion horizontal vertical";
      #   alt-f = "fullscreen";
      # };
    };
  };
}
