{ pkgs }:
# Builds a text sparkline (▁▂▃▄▅▆▇█) from a rolling history of samples.
# sketchybar's native `graph` component collapses to zero height in a vertical
# bar, so we render the history as block-character glyphs in a normal label.
#
# Usage: spark <history-file> <value 0-100> [count]
#   Appends the value, keeps the last N samples, prints an N-char sparkline.
pkgs.writeShellScript "sketchybar-sparkline.sh" ''
  hist_file="$1"
  value="$2"
  n="''${3:-8}"

  # Coerce the value to an integer clamped to 0..100.
  v=$(printf '%.0f' "$value" 2>/dev/null || echo 0)
  [ "$v" -lt 0 ] && v=0
  [ "$v" -gt 100 ] && v=100

  printf '%s\n' "$v" >> "$hist_file"
  tail -n "$n" "$hist_file" > "$hist_file.tmp" 2>/dev/null && mv "$hist_file.tmp" "$hist_file"

  blocks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
  mapfile -t samples < "$hist_file"

  out=""
  # Left-pad with the lowest block until the history fills up.
  pad=$((n - ''${#samples[@]}))
  for ((i = 0; i < pad; i++)); do out="''${out}▁"; done
  for x in "''${samples[@]}"; do
    idx=$((x * 7 / 100))
    [ "$idx" -gt 7 ] && idx=7
    out="''${out}''${blocks[$idx]}"
  done

  printf '%s' "$out"
''
