{
  colors = {
    black = "0xff181926";
    white = "0xffcad3f5";
    red = "0xffed8796";
    green = "0xffa6da95";
    yellow = "0xffeed49f";
    peach = "0xfff5a97f";
    blue = "0xff8aadf4";
    lavender = "0xffb7bdf8";
    barBackground = "0xcc24273a";
    itemBackground = "0xff494d64";
    selectedGray = "0x44ffffff";
  };

  fonts = {
    text = "SF Pro";
    nerd = "JetBrainsMono Nerd Font";
    appIcons = "sketchybar-app-font";
  };

  icons = {
    apple = "";
    preferences = "";
    activity = "";
    lock = "";
    ram = "";
    cpu = "";
    gpu = "󰢮";
    wifi = "";
    battery = {
      "100" = "󰁹";
      "90" = "󰂂";
      "80" = "󰂁";
      "70" = "󰂀";
      "60" = "󰁿";
      "50" = "󰁾";
      "40" = "󰁽";
      "30" = "󰁼";
      "20" = "󰁻";
      "10" = "󰁺";
      "0" = "󰂎";
    };
    batteryCharging = {
      "100" = "󰂅";
      "90" = "󰂋";
      "80" = "󰂊";
      "70" = "󰢞";
      "60" = "󰂉";
      "50" = "󰢝";
      "40" = "󰂈";
      "30" = "󰂇";
      "20" = "󰂆";
      "10" = "󰢜";
      "0" = "󰢟";
    };
  };

  bar = {
    width = 50;
    # Thickness used when the bar sits on top of the built-in laptop screen,
    # sized to match the native menu bar / notch. Tweak to taste.
    menuBarWidth = 32;
    # Background height of the workspace number indicators in the top/menu-bar
    # layout (the docked left layout keeps the larger `spaceBackgroundWidth`).
    menuBarSpaceBackgroundHeight = 20;
    spaceBackgroundHeight = 30;
    # Notch width (points) reserved on the built-in display, and how many of
    # the left-hand app-menu items stay left of the notch before the rest
    # overflow to the right of it. Tune `menusLeftOfNotch` on the laptop.
    notchWidth = 200;
    menusLeftOfNotch = 13;
    # Vertical offset of the detail popups per layout. The docked (left) values
    # likely need tuning on the device. The CPU/RAM/GPU meters sit at the very
    # bottom of the vertical bar, so their popups are pushed up (negative) to
    # keep them from overflowing off the bottom of the screen.
    popupYOffsetTop = 0;
    popupYOffsetLeft = 0;
    popupYOffsetMetricsLeft = -180;
    maxWorkspaceIcons = 10;
    # Horizontal (top/menu-bar) layout only: the total number of app icons the
    # workspace strip is allowed to show at once, matching the widest strip that
    # still fits (see max-amount-right-icons.png in the repo root). Once the
    # workspaces together hold more icons than this, every workspace but the
    # focused one collapses its icons away.
    maxRowAppIcons = 7;
    # Easing curve and duration (frames at 60fps) of the collapse/reveal
    # animation of the workspace app icons.
    appIconAnimationCurve = "sin";
    appIconAnimationFrames = 18;
    maxAppMenus = 12;
  };
}
