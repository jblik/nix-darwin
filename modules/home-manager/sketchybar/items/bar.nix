{ theme, sbar, ... }:
{
  config = ''
    ${sbar} --bar \
      height=${toString theme.bar.width} \
      color=${theme.colors.barBackground} \
      shadow=on \
      position=left \
      sticky=on \
      padding_right=18 \
      padding_left=18 \
      corner_radius=9 \
      y_offset=10 \
      margin=10 \
      blur_radius=20

    ${sbar} --default \
      updates=when_shown \
      icon.font="${theme.fonts.text}:Bold:14.0" \
      icon.color=${theme.colors.white} \
      icon.padding_left=3 \
      icon.padding_right=3 \
      label.font="${theme.fonts.text}:Semibold:13.0" \
      label.color=${theme.colors.white} \
      label.padding_left=3 \
      label.padding_right=3 \
      background.padding_right=3 \
      background.padding_left=3 \
      popup.background.border_width=2 \
      popup.background.corner_radius=11 \
      popup.background.border_color=${theme.colors.white} \
      popup.background.color=${theme.colors.black} \
      popup.background.shadow.drawing=on
  '';
}
