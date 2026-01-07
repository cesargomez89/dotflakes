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
    
    enableGnome = true;
    enableHyprland = false;
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs enableGnome enableHyprland;
        };
        modules = [
          ./nixos/configuration.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cesar = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs stylix enableGnome enableHyprland;
              unstablePkgs = import inputs.nixpkgs-unstable {
                system = "x86_64-linux";
              };
            };
          }
        ];
      };
    };
  };
}
