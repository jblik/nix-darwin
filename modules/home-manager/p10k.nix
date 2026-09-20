{
  user,
  ...
}:
let
  common = builtins.readFile ./dotconfig/p10k-common.zsh;
  overrides = builtins.readFile ./dotconfig/${user.profile}/p10k-overrides.zsh;
in
{
  home.file.".config/p10k/.p10k.zsh".text = common + "\n" + overrides;
}
