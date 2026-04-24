{ profile, ... }:
{
  imports = [
    ./homebrew.nix
    ./nixpackages.nix
    ./${profile}
  ];
}
