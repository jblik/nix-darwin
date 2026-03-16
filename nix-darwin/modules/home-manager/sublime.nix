{ config, lib, pkgs, ... }:

{
    home.file."Library/Application Support/Sublime Text/Packages/User/Default (OSX).sublime-keymap".text = ''
        [
        	{ "keys": ["super+alt+l"], "command": "reindent" , "args": { "single_line": false } },
        	{ "keys": ["ctrl+super+shift+up"], "command": "swap_line_up" },
        	{ "keys": ["ctrl+super+shift+down"], "command": "swap_line_down" },
        	{ "keys": ["ctrl+super+up"], "command": "unbound" },
        	{ "keys": ["ctrl+super+down"], "command": "unbound" },
        	{ "keys": ["super+ctrl+f"], "command": "unbound" }
        ]
    '';
}