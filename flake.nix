{
  description = "Personal flakes, including NixOS & home-manager configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-search = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypraise = {
      url = "github:knarkzel/raise";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      inherit (self) outputs;
      user_id = 1000;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
        system = system;
      };
      network = import ./network.nix;
    in rec {
      packages.${system} = import ./packages { inherit pkgs; };

      modules = import ./modules;

      overlays.default = final: prev: import ./packages { pkgs = final; };

      nixosConfigurations.mystix = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs inputs outputs network user_id; };
        modules = pkgs.lib.attrValues modules.nixos ++ [
          ./mystix/configuration.nix
        ];
      };

      nixosConfigurations.regis = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs network; };
        modules = pkgs.lib.attrValues modules.nixos ++ [
          ./regis/configuration.nix
        ];
      };
    };
}
