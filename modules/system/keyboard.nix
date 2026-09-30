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
          "com.mitchellh.ghostty - New Ghostty Window Here - openWindow" = {
            key_equivalent = "^$t";
          };
        };
        "com.apple.Safari" = {
          IncludeDevelopMenu = true; # doesn't technically belong here but eh
          NSUserKeyEquivalents = {
            "Move Tab to New Window" = "~m";
            "Merge All Windows" = "~@m";
          };
        };
      };
    };
  };
}
