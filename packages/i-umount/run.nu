#!/usr/bin/env nu

let data = (sys | get disks | to json -r | jq -c ".[]")
let header = "Select path to unmount, Ctrl+C or ESC to abort"
let preview = "sys | get disks | where mount == {} | to text"
let selected_mount = echo $data | jq -r ".mount" | fzf --scheme=path --layout=reverse $"--header=($header)" $"--preview=($preview)" | complete

if $selected_mount.exit_code == 0 {
  let target = ($selected_mount.stdout | str trim)
  udiskie-umount $target
}
