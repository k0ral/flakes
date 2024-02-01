#!/usr/bin/env nu

let temp_file = (mktemp)
let text = (wl-paste -p)
echo $text | qrencode -t SVG -o $temp_file
notify-send "QR-code generated" $text
imv $temp_file
rm $temp_file
