#!/usr/bin/env nu

def wallhaven-tags [] {
  let tag = (cat ~/.config/secrets/wallhaven.yaml | yq ".tags[]" | shuffle | first)
  let url = (^http GET "https://wallhaven.cc/api/v1/search" "categories==101" "purity==100" "sorting==random" "atleast==1920x1080" "ratios==16x9" $"q==id:($tag)" | jq -r ".data[0].path")
  rm -rf /tmp/wallpaper
  echo $"Downloading ($url)"
  aria2c -d /tmp -o wallpaper $"($url)"
}

def wallhaven-random [] {
  let url = (^http GET "https://wallhaven.cc/api/v1/search" "categories==101" "purity==100" "sorting==random" "atleast==1920x1080" "ratios==16x9" | jq -r ".data[0].path")
  rm -rf /tmp/wallpaper
  echo $"Downloading ($url)"
  aria2c -d /tmp -o wallpaper $"($url)"
}

echo $"Using WAYLAND_DISPLAY=($env.WAYLAND_DISPLAY)"
wallhaven-tags
swaybg -m stretch -o "*" -i /tmp/wallpaper
