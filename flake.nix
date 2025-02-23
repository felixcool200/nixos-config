{
  description = "NixOS configuration for felixcool200";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nur.url = "github:nix-community/NUR";  # Use NUR as a flake
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  # Keep same nixpkgs version
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager  # Home Manager as a module
        nur.modules.nixos.default  # Proper NUR module from flakes
        {
          home-manager.backupFileExtension = "backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.felixcool200 = import ./home.nix;
        }
      ];
    };
  };
}

