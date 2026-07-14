{ sbar, theme }:
# Shared two-column popup row: an icon-labelled left column and a right-aligned
# value. Used by the battery / network / cpu / ram / gpu detail popups so their
# styling stays in one place.
#
# Usage: mkRow { name = "battery.charge"; parent = "battery"; width = 190; }
{
  name,
  parent,
  width ? 190,
  labelColor ? theme.colors.lavender,
}:
''
  ${sbar} --add item ${name} popup.${parent} \
    --set ${name} \
      width=${toString width} \
      icon.font="${theme.fonts.text}:Semibold:12.0" \
      icon.color=${theme.colors.white} \
      icon.padding_left=10 \
      icon.align=left \
      label.font="${theme.fonts.text}:Semibold:12.0" \
      label.color=${labelColor} \
      label.padding_right=10 \
      label.align=right
''
