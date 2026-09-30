{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.prismlauncher
  ];

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  home.file."Library/Java/JavaVirtualMachines/zulu-25.jdk".source =
    "${config.programs.java.package}/Library/Java/JavaVirtualMachines/zulu-25.jdk";
}
