{ user, ... }:
{
  imports = [
    ./homebrew.nix
    ./nixpackages.nix
    ./${user.profile}
  ];
}
