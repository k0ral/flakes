#!/usr/bin/env nu

let outputs = (hyprctl -j monitors | from json | get name | to text)
let header = "Select output to disable, Ctrl+C or ESC to abort"
let preview = "hyprctl -j monitors | from json | where name == {} | transpose | table -i false -e"
let selected = echo $outputs | fzf --layout=reverse $"--header=($header)" $"--preview=($preview)" | complete

if $selected.exit_code == 0 {
  let target = ($selected.stdout | str trim)
  hyprctl keyword monitor $"($target), disable"
  notify-send $"Disabled output ($target)"
}
