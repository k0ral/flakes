build:
  sudo nixos-rebuild build --flake .
switch:
  sudo nixos-rebuild switch --flake .
update:
  sudo nix flake update
