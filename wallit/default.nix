{ pkgs, ... }:

rec {
  wallhaven-tags = pkgs.writeShellScriptBin "wallhaven-tags" ''
    TAG=$(${pkgs.coreutils}/bin/cat ''${XDG_CONFIG_HOME:-~/.config}/secrets/wallhaven.yaml | ${pkgs.yq}/bin/yq ".tags[]" | ${pkgs.coreutils}/bin/shuf -n1)

    URL=$(${pkgs.httpie}/bin/http GET "https://wallhaven.cc/api/v1/search" "categories==101" "purity==100" "sorting==random" "atleast==1920x1080" "ratios==16x9" "q==id:$TAG" | ${pkgs.jq}/bin/jq -r ".data[0].path")
    ${pkgs.coreutils}/bin/rm -r /tmp/wallpaper
    echo "Downloading $URL"
    ${pkgs.aria2}/bin/aria2c -d /tmp -o wallpaper "$URL"
  '';

  wallhaven-random = pkgs.writeShellScriptBin "wallhaven-random" ''
    URL=$(${pkgs.httpie}/bin/http GET "https://wallhaven.cc/api/v1/search" "categories==101" "purity==100" "sorting==random" "atleast==1920x1080" "ratios==16x9" | ${pkgs.jq}/bin/jq -r ".data[0].path")
    ${pkgs.coreutils}/bin/rm -r /tmp/wallpaper
    echo "Downloading $URL"
    ${pkgs.aria2}/bin/aria2c -d /tmp -o wallpaper "$URL"
  '';

  wallit = pkgs.writeShellScriptBin "wallit" ''
    ${wallhaven-tags}/bin/wallhaven-tags
    ${pkgs.sway}/bin/swaymsg output '*' bg /tmp/wallpaper stretch
  '';
}
