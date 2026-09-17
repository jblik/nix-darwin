{
  user,
  ...
}:
{
  imports = [
    ./direnv.nix
    ./homebrew.nix
    ./nixpackages.nix
    ./${user.profile}
  ];
}
