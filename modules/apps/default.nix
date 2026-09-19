{
  user,
  ...
}:
{
  imports = [
    ./direnv.nix
    ./homebrew.nix
    ./jetbrains-shared.nix
    ./nixpackages.nix
    ./${user.profile}
  ];
}
