{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = [
    pkgs._1password-cli
    pkgs.azure-cli
    pkgs.bruno # foss postman
    pkgs-unstable.claude-code # anthropic code tool
  ];
}
