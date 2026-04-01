{ homeDirectory, username, ... }:
# todo: edit to be multi-user
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
        NSGlobalDomain.NSUserKeyEquivalents = {
          # if a backslash is needed, we cannot place them here:
          # https://github.com/NixOS/nix/issues/10082
          # https://github.com/nix-darwin/nix-darwin/issues/518
          "Fill" = "@^f"; # Cmd+Ctrl+F
          "Full Screen" = "@^$f"; # Cmd+Ctrl+Shift+F
          "Enter Full Screen" = "@^$f"; # Cmd+Ctrl+Shift+F
          "Toggle Full Screen" = "@^$f";
        };
        pbs.NSServicesStatus = {
          # this maps to Services>Files and Folders
          "com.mitchellh.ghostty - New Ghostty Window Here - openWindow" = {
            key_equivalent = "^$t";
          };
        };
      };
    };

    activationScripts.postActivation.text = ''
      echo "adding additional keyboard settings defined in keyboard.nix..."
      # resets manually defined keyboard shortcuts (settings/keyboard shortcuts/all applications)
      sudo -u ${username} defaults delete NSGlobalDomain NSUserKeyEquivalents 2>/dev/null || true
      sudo -u ${username} defaults delete /${homeDirectory}/Library/Preferences/com.apple.Safari.plist NSUserKeyEquivalents 2>/dev/null || true

      # see the above issues as to why these aren't declared in the CustomUserPreferences block:
      sudo -u ${username} defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Move to SAMSUNG" '@~^\U2192'
      sudo -u ${username} defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Move to Built-in Retina Display" '@~^\U2192'
      sudo -u ${username} defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Move to E241N" '@~^\U2190'
      sudo -u ${username} defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Move to S34C65xV" '@~^\U2190'

      # Safari is sandboxed and ignores NSGlobalDomain
      sudo -u ${username} defaults write /${homeDirectory}/Library/Preferences/com.apple.Safari.plist NSUserKeyEquivalents -dict-add "Fill" '@^f'
      sudo -u ${username} defaults write /${homeDirectory}/Library/Preferences/com.apple.Safari.plist NSUserKeyEquivalents -dict-add "Full Screen" '@^$f'
      sudo -u ${username} defaults write /${homeDirectory}/Library/Preferences/com.apple.Safari.plist NSUserKeyEquivalents -dict-add "Enter Full Screen" '@^$f'
      sudo -u ${username} defaults write /${homeDirectory}/Library/Preferences/com.apple.Safari.plist NSUserKeyEquivalents -dict-add "Toggle Full Screen" '@^$f'
      sudo -u ${username} defaults write /${homeDirectory}/Library/Preferences/com.apple.Safari.plist NSUserKeyEquivalents -dict-add "Show Web Inspector" '\\Uf70f'
      sudo -u ${username} defaults write /${homeDirectory}/Library/Preferences/com.apple.Safari.plist NSUserKeyEquivalents -dict-add "Close Web Inspector" '\\Uf70f'

      # Following line should allow us to avoid a logout/login cycle when changing settings
      sudo -u ${username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
