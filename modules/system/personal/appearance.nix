{
  pkgs-unstable,
  users,
  ...
}:
{
  system.defaults.dock = {
    autohide = true;
    orientation = "bottom";
    persistent-apps = [
      "/Applications/Ghostty.app"
      "/Applications/IntelliJ IDEA.app"
      "/Applications/Rider.app"
      "/Applications/DataGrip.app"
      "/Applications/PyCharm.app"
      "/Applications/Sublime Text.app"
      {
        spacer = {
          small = true;
        };
      }
      "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
      "/System/Applications/Messages.app"
      "/System/Applications/System Settings.app"
      "/System/Applications/Utilities/Activity Monitor.app"
      "/System/Applications/iPhone Mirroring.app"
      {
        spacer = {
          small = true;
        };
      }
    ];
    persistent-others = [
      {
        folder = {
          path = "${users.personal.homeDirectory}/Documents/Screenshots";
          arrangement = "date-added";
          showas = "fan";
        };
      }
      {
        folder = {
          path = "${users.personal.homeDirectory}/Downloads";
          arrangement = "date-added";
          showas = "fan";
        };
      }
    ];
    autohide-delay = 0.0;
    show-recents = false;
    tilesize = 62;
  };

  system.defaults.loginwindow.LoginwindowText = "Hello!";
}
