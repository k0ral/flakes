#!/usr/bin/env nu

let outputs = (swaymsg -r -t get_outputs | jq -r ".[] | select(.active == true) | .name")
let header = "Select output to disable, Ctrl+C or ESC to abort"
let preview = "swaymsg -r -t get_outputs | from json | where name == {} | transpose | table -i false -e"
let selected = echo $outputs | fzf --layout=reverse $"--header=($header)" $"--preview=($preview)" | complete

if $selected.exit_code == 0 {
  let target = ($selected.stdout | str trim)
  swaymsg output $target disable
  notify-send $"Disabled output ($target)"
}
