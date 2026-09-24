{
  lib,
  pkgs,
  ...
}:
{
  home.file."Library/Application Support/Sublime Text/Packages/User/Default (OSX).sublime-keymap".text =
    ''
      [
        { "keys": ["super+alt+l"], "command": "reindent" , "args": { "single_line": false } },
        { "keys": ["ctrl+super+shift+up"], "command": "swap_line_up" },
        { "keys": ["ctrl+super+shift+down"], "command": "swap_line_down" },
        { "keys": ["ctrl+super+up"], "command": "unbound" },
        { "keys": ["ctrl+super+down"], "command": "unbound" },
        { "keys": ["super+ctrl+f"], "command": "unbound" },
        { "keys": ["ctrl+w"], "command": "close" },
        { "keys": ["super+w"], "command": "expand_selection", "args": {"to": "smart"} },
        { "keys": ["super+shift+w"], "command": "soft_undo" }
      ]
    '';

  home.activation.setDefaultApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "setting default apps with duti..."

    for ext in .txt .md .json .yaml .yml .toml .ini .cfg .log .csv \
               .js .ts .tsx .fs .sh .zsh .bash .c .h .cpp \
               .xml .sql public.plain-text; do
      run ${lib.getExe pkgs.duti} -s com.sublimetext.4 $ext all
    done
  '';
}
