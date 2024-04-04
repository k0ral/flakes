#!/usr/bin/env nu

let outputs = (hyprctl -j monitors all | from json | get name | to text)
let header = "Select output to enable, Ctrl+C or ESC to abort"
let preview = "hyprctl -j monitors all | from json | where name == {} | transpose | table -i false -e"
let selected = echo $outputs | fzf --layout=reverse $"--header=($header)" $"--preview=($preview)" | complete

if $selected.exit_code == 0 {
  let target = ($selected.stdout | str trim)
  hyprctl keyword monitor $"($target), preferred, auto, 1"
  notify-send $"Enabled output $(target)"
}
