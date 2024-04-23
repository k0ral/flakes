build:
  sudo nixos-rebuild build --flake .#mystix
switch:
  sudo nixos-rebuild switch --flake .#mystix
deploy-regis:
  sudo nixos-rebuild switch --flake .#regis --target-host koral@192.168.1.11 --use-remote-sudo
update:
  sudo nix flake update
