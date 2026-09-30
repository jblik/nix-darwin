# reference other modules
{
  # imports = [
  #   ./apps/default.nix
  #   ./system/default.nix
  #   ./security/default.nix
  # ];
    system.defaults.loginwindow = {
    GuestEnabled = false; # Disable guest account
    LoginwindowText = "Is this yours?"; # Set login window text
    # Add more loginwindow settings here
  };
}