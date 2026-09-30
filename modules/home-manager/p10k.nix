{ user, ... }:

{
  home.file.".config/p10k/.p10k.zsh".source = ./dotconfig/${user.profile}/p10k.zsh;
}
