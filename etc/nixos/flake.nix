{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { nixpkgs, sops-nix ... } @ inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {

      # Target architecture
      system = "aarch64-linux";

      specialArgs = {
        inherit sops-nix;
      };

      modules = [
        # Configures the kernel and bootloader
        # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/3/default.nix
        "${inputs.nixos-hardware}/raspberry-pi/3"

        # My image config
        ./configuration.nix

        # Handle encrypted secrets
        ./secrets/.nix
      ];

    };
  };
}