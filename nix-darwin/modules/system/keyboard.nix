{ config, pkgs, lib, ... }:

{ 
    system.keyboard = {
        swapLeftCtrlAndFn = false; # Swap left control and function keys
        enableKeyMapping = true; # Enable key mapping
    };
    
    system.defaults.NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true; # use f keys as f keys
    };

    system.defaults.CustomUserPreferences = {
        NSGlobalDomain = {
            NSUserKeyEquivalents = {
               "Move to SAMSUNG" = ''@~^\\U2192''; # Cmd+Alt+Ctrl+Right Arrow
               "Move to E241N" = ''@~^\\U2190''; # Cmd+Alt+Ctrl+Left Arrow
               "Move to S34C65xV" = ''@~^\\U2190''; # Cmd+Alt+Ctrl+Left Arrow
               "Fill" = ''@^F''; #Cmd+Ctrl+F
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
    system.activationScripts.postActivation.text = lib.mkAfter ''
        echo "Resetting 'All Application' declared keyboard shortcuts to declarative-only..."
        defaults delete NSGlobalDomain NSUserKeyEquivalents 2>/dev/null || true
    '';
}