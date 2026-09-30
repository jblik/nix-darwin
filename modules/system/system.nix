{
  security.pam.services.sudo_local.touchIdAuth = true;

  # the flake repo is owned by one user, so libgit2 (used by nix under sudo) rejects it for every other user and root
  environment.etc."gitconfig".text = ''
    [safe]
      directory = /etc/nix-darwin
      directory = /private/etc/nix-darwin
  '';
}
