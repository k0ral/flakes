#!/usr/bin/env nu

let data = (swaymsg -t get_tree | jq -c 'recurse(.nodes[]) | select(.window != -1 and .type == "con")')
let candidates = ($data | jq -c '{id:.id, app_id:.app_id, class:.window_properties.class, name:.name}')
let selected = ($candidates | fzf --header='Switch to:' | complete)

if $selected.exit_code == 0 {
  let id = (echo $selected.stdout | str trim | jq -r ".id")
  swaymsg $"[con_id=($id)] focus"
}
