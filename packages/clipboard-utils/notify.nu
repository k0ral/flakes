#!/usr/bin/env nu

let clipboard = (wl-paste)
let primary = (wl-paste -p)

notify-send "Clipboard" $clipboard
notify-send "Primary" $primary
