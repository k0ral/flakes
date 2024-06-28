{
  home = {
    android = ./home/essential/android.nix;
    audio = ./home/essential/audio.nix;
    bluetooth = ./home/essential/bluetooth.nix;
    core = ./home/essential/core.nix;
    dev = ./home/essential/dev.nix;
    multimedia = ./home/essential/multimedia.nix;
    nix = ./home/essential/nix.nix;

    clipboard-utils = ./home/wayland/clipboard-utils.nix;
    fuzzel = ./home/wayland/fuzzel.nix;
    i3status-rust = ./home/wayland/i3status-rust.nix;
    hyprland = ./home/wayland/hyprland.nix;
    sway = ./home/wayland/sway.nix;
    wallit = ./home/wayland/wallit.nix;
    waybar = ./home/wayland/waybar.nix;

    beets = ./home/beets.nix;
    btop = ./home/btop.nix;
    compression = ./home/compression.nix;
    containers = ./home/containers.nix;
    detox = ./home/detox.nix;
    ferdium = ./home/ferdium.nix;
    ffmpeg = ./home/ffmpeg/default.nix;
    fish = ./home/fish.nix;
    foot = ./home/foot.nix;
    git = ./home/git.nix;
    golang = ./home/golang.nix;
    haskell = ./home/haskell.nix;
    kubernetes = ./home/kubernetes.nix;
    librewolf = ./home/librewolf.nix;
    mpv = ./home/mpv.nix;
    ncmpcpp = ./home/ncmpcpp.nix;
    neovim = ./home/neovim/default.nix;
    nixlang = ./home/nixlang.nix;
    nushell = ./home/nushell.nix;
    python = ./home/python.nix;
    s = ./home/s.nix;
    trash = ./home/trash.nix;
    us-qwerty-fr = ./home/us-qwerty-fr.nix;
  };

  nixos = {
    adguardhome = ./nixos/adguardhome.nix;
    base = ./nixos/base.nix;
    home-assistant = ./nixos/home-assistant.nix;
    ntfs = ./nixos/ntfs.nix;
    ntfy = ./nixos/ntfy.nix;
  };
}
