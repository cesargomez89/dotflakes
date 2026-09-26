{
  description = "NixOS + macOS dotfiles";

  inputs = {
    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not following nixpkgs on purpose: keeps hits on the numtide binary cache.
    llm-agents.url = "github:numtide/llm-agents.nix";

    llama-cpp = {
      url = "github:ggml-org/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      stylix,
      lanzaboote,
      home-manager,
      nix-darwin,
      nix-homebrew,
      mac-app-util,
      ...
    }@inputs:

    let
      username = "cesar";

      specialArgs = { inherit inputs username; };

      homeManagerModule = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = import ./home-manager/home.nix;
          extraSpecialArgs = specialArgs;
        };
      };

      makeNixosConfiguration =
        configPath:
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            stylix.nixosModules.stylix
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            homeManagerModule
            configPath
          ];
        };

      makeDarwinConfiguration =
        configPath:
        nix-darwin.lib.darwinSystem {
          inherit specialArgs;

          modules = [
            { nixpkgs.config.allowUnfree = true; }

            stylix.darwinModules.stylix
            nix-homebrew.darwinModules.nix-homebrew
            mac-app-util.darwinModules.default

            home-manager.darwinModules.home-manager
            homeManagerModule

            configPath
          ];
        };

      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {
      nixosConfigurations = {
        desktop-amd = makeNixosConfiguration ./nixos/machines/desktop-amd/configuration.nix;
      };

      darwinConfigurations = {
        macbook-pro = makeDarwinConfiguration ./darwin/machines/macbook-pro/configuration.nix;
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
