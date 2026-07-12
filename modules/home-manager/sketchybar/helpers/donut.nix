{ pkgs }:
# Draws a donut/ring PNG showing `pct` filled, using ImageMagick.
# sketchybar has no native pie/donut, so we render an image and set it as the
# item's background. Rendered @2x for retina crispness (display with scale=0.5).
#
# Usage: donut <out.png> <pct 0-100> <fill #rrggbb> [track #rrggbb]
pkgs.writeShellScript "sketchybar-donut.sh" ''
  out="$1"
  pct="$2"
  fill="$3"
  track="''${4:-#494d64}"

  mkdir -p "$(dirname "$out")"

  # Clamp to an integer 0..100.
  p=$(printf '%.0f' "$pct" 2>/dev/null || echo 0)
  [ "$p" -lt 0 ] && p=0
  [ "$p" -gt 100 ] && p=100

  # Arc sweeps clockwise from 12 o'clock (270deg in ImageMagick's frame).
  end=$(awk "BEGIN { printf \"%d\", 270 + $p * 360 / 100 }")

  # Track ring (full circle).
  draw=(-draw "fill none stroke-linecap round stroke $track stroke-width 12 ellipse 44,44 32,32 0,360")
  # Used arc (skip at 0% so a round cap doesn't leave a dot).
  if [ "$p" -gt 0 ]; then
    draw+=(-draw "fill none stroke-linecap round stroke $fill stroke-width 12 ellipse 44,44 32,32 270,$end")
  fi

  ${pkgs.imagemagick}/bin/magick -size 88x88 xc:none "''${draw[@]}" "$out"
''
