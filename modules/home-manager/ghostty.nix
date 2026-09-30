{
  home.file."Library/Application Support/com.mitchellh.ghostty/config.ghostty".text = ''
    font-family = "JetBrainsMono Nerd Font"
    shell-integration-features = ssh-terminfo

    background-opacity = 0.8
    unfocused-split-opacity = 0.5
    background-blur = 5
    background = black
    foreground = green
    macos-titlebar-style = hidden

    shell-integration-features = no-cursor
    cursor-style = block_hollow

    font-thicken = true
    font-thicken-strength = 1

    keybind = super+alt+j=goto_split:down
    keybind = super+alt+h=goto_split:left
    keybind = super+alt+l=goto_split:right
    keybind = super+alt+k=goto_split:up
    keybind = super+t=new_split:down
    keybind = super+shift+t=new_split:right
    keybind = super+ctrl+j=resize_split:down,10
    keybind = super+ctrl+h=resize_split:left,10
    keybind = super+ctrl+l=resize_split:right,10
    keybind = super+ctrl+k=resize_split:up,10
    keybind = super+ctrl+shift+j=resize_split:down,25
    keybind = super+ctrl+shift+h=resize_split:left,25
    keybind = super+ctrl+shift+l=resize_split:right,25
    keybind = super+ctrl+shift+k=resize_split:up,25
  '';
}
