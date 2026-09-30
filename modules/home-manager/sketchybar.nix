{ pkgs, ... }:
{
  # Home-manager has no native sketchybar module, so wire it up by hand:
  # install the package, drop in the rc config, and run it via a launchd agent.
  home.packages = [ pkgs.sketchybar ];

  home.file.".config/sketchybar/sketchybarrc" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # --- Bar appearance ---
      sketchybar --bar \
        height=32 \
        position=top \
        padding_left=8 \
        padding_right=8 \
        color=0xff1e1e2e

      # --- Defaults applied to every item ---
      sketchybar --default \
        icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
        label.font="JetBrainsMono Nerd Font:Bold:14.0" \
        icon.color=0xffffffff \
        label.color=0xffffffff \
        padding_left=6 \
        padding_right=6

      # --- Front app name (left) ---
      sketchybar --add item front_app left \
        --set front_app script="sketchybar --set front_app label=\"$INFO\"" \
        --subscribe front_app front_app_switched

      # --- Clock (right) ---
      sketchybar --add item clock right \
        --set clock update_freq=10 \
        script="sketchybar --set clock label=\"$(date '+%a %d %b  %H:%M')\""

      # --- Finalize ---
      sketchybar --update
    '';
  };

  launchd.agents.sketchybar = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.sketchybar}/bin/sketchybar" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/sketchybar.out.log";
      StandardErrorPath = "/tmp/sketchybar.err.log";
      EnvironmentVariables = {
        PATH = "${pkgs.sketchybar}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
