{ config, pkgs, lib, ... }:

{ 
    system.keyboard = {
        swapLeftCtrlAndFn = false; # Swap left control and function keys
        enableKeyMapping = true; # Enable key mapping
    };

    # KEYBOARD SHORTCUTS 
    system.defaults.CustomUserPreferences = {
        NSGlobalDomain = {
            NSUserKeyEquivalents = {
                "Move to SAMSUNG" = ''@~^\\U2192''; # Cmd+Ctrl+Alt+Right Arrow
                "Move to E241N" = ''@~^\\U2190''; # Cmd+Ctrl+Alt+Left Arrow
                "Move to S34C65xV" = ''@~^\\U2190''; # Cmd+Ctrl+Alt+Left Arrow
            };
        };
    };

    system.defaults.CustomSystemPreferences = {
        "com.apple.Safari" = {
            "com.apple.Safari.NSUserKeyEquivalents.Show Web Inspector" = ''\\Uf70f''; # f12
            "com.apple.Safari.NSUserKeyEquivalents.Close Web Inspector" = ''\\Uf70f''; # f12
        };
    };
    
    # deletes all CUSTOM keyboard shortcuts for all apps (settings/keyboard shortcuts/all applications)
    # todo: candidate to get moved, can only have one post activation script flake-wide.
    system.activationScripts.postActivation.text = ''
        echo "Resetting 'All Application' declared keyboard shortcuts to declarative-only..."
        defaults delete NSGlobalDomain NSUserKeyEquivalents 2>/dev/null || true
    '';
}