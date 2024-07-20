build:
  sudo nixos-rebuild build --flake .#mystix
  nvd diff /run/current-system ./result
switch:
  sudo nixos-rebuild switch --flake .#mystix
deploy-regis:
  nixos-rebuild switch --flake .#regis --build-host koral@192.168.1.11 --target-host koral@192.168.1.11 --use-remote-sudo
update:
  sudo nix flake update
