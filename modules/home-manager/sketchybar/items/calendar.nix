{ theme, sbar, ... }:
{
  config = ''
    ${sbar} --add item calendar right \
      --set calendar \
        icon=cal \
        icon.color=${theme.colors.black} \
        icon.font="${theme.fonts.text}:Black:12.0" \
        icon.padding_left=5 \
        icon.padding_right=5 \
        icon.drawing=off \
        label.color=${theme.colors.black} \
        label.padding_left=5 \
        label.padding_right=5 \
        background.color=0xffb8c0e0 \
        background.height=26 \
        background.corner_radius=11
  '';
}
