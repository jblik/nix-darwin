{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = [
    pkgs-unstable.codex # openai code tool
    pkgs-unstable.gemini-cli-bin # google code tool
    pkgs.prismlauncher
  ];

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  home.file."Library/Java/JavaVirtualMachines/zulu-25.jdk".source =
    "${config.programs.java.package}/Library/Java/JavaVirtualMachines/zulu-25.jdk";
}
