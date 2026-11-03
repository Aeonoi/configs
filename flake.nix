{
  description = "NixOs Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    hosts = [
      "flover-nixos" # p1g4
    ];
  in
  {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts (name:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${name}
          inputs.home-manager.nixosModules.default
        ];
      }
    );
  };
}
