{ profile, ... }:

{
  home.file.".config/p10k/.p10k.zsh".source = ../dotconfig/${profile}/p10k.zsh;
}
