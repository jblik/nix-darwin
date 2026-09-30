{
  user,
  ...
}:
{
  imports = [
    ./${user.profile}/applications.nix
  ];
}
