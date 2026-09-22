{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs; [
    _1password-cli
    azure-cli
    bruno # foss postman
  ] ++ [
    pkgs-unstable.claude-code # anthropic code tool
  ];
}
