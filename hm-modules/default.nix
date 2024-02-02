{
  # Add your home-manager modules here
  android = ./essential/android.nix;
  audio = ./essential/audio.nix;
  bluetooth = ./essential/bluetooth.nix;
  core = ./essential/core.nix;
  dev = ./essential/dev.nix;
  multimedia = ./essential/multimedia.nix;
  nix = ./essential/nix.nix;

  beets = ./beets.nix;
  btop = ./btop.nix;
  compression = ./compression.nix;
  containers = ./containers.nix;
  detox = ./detox.nix;
  ferdium = ./ferdium.nix;
  ffmpeg = ./ffmpeg/default.nix;
  fish = ./fish.nix;
  foot = ./foot.nix;
  fuzzel = ./fuzzel.nix;
  git = ./git.nix;
  golang = ./golang.nix;
  haskell = ./haskell.nix;
  i3status-rust = ./i3status-rust.nix;
  kubernetes = ./kubernetes.nix;
  mpv = ./mpv.nix;
  ncmpcpp = ./ncmpcpp.nix;
  neovim = ./neovim/default.nix;
  nixlang = ./nixlang.nix;
  nushell = ./nushell.nix;
  python = ./python.nix;
  sway = ./sway.nix;
  trash = ./trash.nix;
  us-qwerty-fr = ./us-qwerty-fr.nix;
}
