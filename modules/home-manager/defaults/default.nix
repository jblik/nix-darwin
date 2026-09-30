{ lib, ... }:
{
  imports = [
    ./appearance.nix
    ./finder.nix
    ./keyboard.nix
    ./trackpad.nix
  ];

  # the dock only picks up changed defaults after a restart
  home.activation.restartDock = lib.hm.dag.entryAfter [ "setDarwinDefaults" ] ''
    run /usr/bin/killall -qu "$USER" Dock || true
  '';
}
