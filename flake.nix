{
  description = "Personal flakes, including NixOS & home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        config.pulseaudio = true; # TODO: false
        overlays = [ self.overlays.default ];
        system = system;
      };
    in rec {
      packages.${system} = import ./packages { inherit pkgs; }
        // import ./quottit { inherit pkgs; }
        // import ./wallit { inherit pkgs; };

      hm-modules = import ./hm-modules;

      overlays.default = self: super: {
        nerdfonts = super.nerdfonts.override { fonts = [ "VictorMono" ]; };
        oauth2l = packages.${system}.oauth2l;
        quottit = packages.${system}.quottit;
        qwerty-fr = packages.${system}.qwerty-fr;
        statusbar-utils = packages.${system}.statusbar-utils;
        wallit = packages.${system}.wallit;
      };

      nixosConfigurations.mystix = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit pkgs; };
            home-manager.sharedModules = nixpkgs.lib.attrValues hm-modules;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.koral = import ./home-manager/home.nix;
          }
        ];
      };
    };
}
