{ profile, ... }:
{
  imports = [
    ./apps
    ./system
    ./${profile}
  ];
}
