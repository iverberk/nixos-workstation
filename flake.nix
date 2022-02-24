{
  description = "NixOS Workstation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    overlays = [
      inputs.neovim-nightly-overlay.overlay

      (final: prev: {
        # To get Kitty 0.24.x. Delete this once it hits release.
        kitty = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kitty;
      })
    ];
  in {
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nixpkgs.overlays = overlays; }

        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.iverberk = import ./home.nix;
        }
      ];
    };
  };
}
