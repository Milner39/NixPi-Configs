{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    sops-nix,
    ...
  } @ inputs: let

    # Declare target architecture
    system = "aarch64-linux";

    # Import packages
    pkgs = nixpkgs.legacyPackages.${system};


    # Additional NixOS inputs
    specialArgs = { inherit inputs nixos-hardware sops-nix; };

    # Additional Home Manager inputs
    extraSpecialArgs = {};

  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = [
        ./hosts/default/configuration.nix
        ./hosts/default/secrets/sops.nix
      ];
    };
  };
}