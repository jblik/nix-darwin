{
  system = {
    keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true; # use f keys as f keys
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleKeyboardUIMode = 2; # enable keyboard navigation
      };

      CustomUserPreferences = {
        pbs.NSServicesStatus = {
          # this maps to Services>Files and Folders
          "com.mitchellh.ghostty - New Ghostty Window Here - openWindow".key_equivalent = "^$t"; # Ctrl+Shift+t
        };
        "com.apple.Safari" = {
          IncludeDevelopMenu = true; # doesn't technically belong here but eh
          NSUserKeyEquivalents = {
            "Move Tab to New Window" = "~@m"; # Alt+Cmd+M
            "Move Tab to New Private Window" = "~@m"; # Alt+Cmd+M
            "Merge All Windows" = "~@$m"; # Alt+Cmd+Shift+M
          };
        };
        NSGlobalDomain.NSUserKeyEquivalents = {
          # if a backslash is needed (as escape char like f12), we cannot place them here:
          # https://github.com/NixOS/nix/issues/10082
          # https://github.com/nix-darwin/nix-darwin/issues/518
          "Show Notification Center" = "~'"; # Alt+'
        };
      };
    };
  };
}
