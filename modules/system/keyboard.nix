{ config, pkgs, lib, ... }:

{ 
    system.keyboard = {
        enableKeyMapping = true; # Enable key mapping
        nonUS.remapTilde = true;
        remapCapsLockToControl = true;
    };
    
    system.defaults.NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true; # use f keys as f keys
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleKeyboardUIMode = 2; # enable keyboard navigation
    };

     # deletes all CUSTOM keyboard shortcuts for all apps (settings/keyboard shortcuts/all applications)
     system.activationScripts.postActivation.text = ''
         echo "resetting manually set keyboard shortcuts"
         defaults delete NSGlobalDomain NSUserKeyEquivalents 2>/dev/null || true
     '';

    system.defaults.CustomUserPreferences = {
        NSGlobalDomain = {
            NSUserKeyEquivalents = {
               "Move to SAMSUNG" = ''@~^U2192''; # Cmd+Alt+Ctrl+Right Arrow
               "Move to Built-in Retina Display" = ''@~^U2192''; # Cmd+Alt+Ctrl+Right Arrow (left arrow seems to be '\') todo these are being set to '@~^\\\\\\\\U2192'
               "Move to E241N" = ''@~^U2190''; # Cmd+Alt+Ctrl+Left Arrow
               "Move to S34C65xV" = ''@~^U2190''; # Cmd+Alt+Ctrl+Left Arrow
               "Fill" = ''@^f''; #Cmd+Ctrl+F
               "Full Screen" = ''@^$f''; #Cmd+Ctrl+Shift+F
           };
        };
        pbs = {
         # this maps to Services>Files and Folders
          NSServicesStatus = {
            "com.mitchellh.ghostty - New Ghostty Window Here - openWindow" = {
              key_equivalent = ''^$t'';
            };
          };
        };
    };

    system.defaults.CustomSystemPreferences = {
        "com.apple.Safari" = {
            "com.apple.Safari.NSUserKeyEquivalents.Show Web Inspector" = ''\\Uf70f''; # f12
            "com.apple.Safari.NSUserKeyEquivalents.Close Web Inspector" = ''\\Uf70f''; # f12
        };
    };
}