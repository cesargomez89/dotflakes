{
  description = "NixOS + Hyprland dotfiles";

  inputs = {
    stylix.url = "github:danth/stylix/release-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    stylix,
    lanzaboote,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
    
    enableGnome = true;
    enableHyprland = false;
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs enableGnome enableHyprland unstablePkgs;
        };
        modules = [
          inputs.stylix.nixosModules.stylix
          ./nixos/configuration.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            nixpkgs = {
              overlays = [
                (final: prev: {
                  unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
                })
              ];
              config = {
                allowUnfree = true;
              };
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cesar = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs stylix enableGnome enableHyprland unstablePkgs;
            };
          }
        ];
      };
    };
  };
}
