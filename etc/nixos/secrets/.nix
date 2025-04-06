{ sops-nix, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops = {
    # File to decrypt
    defaultSopsFile = ./.json;
    defaultSopsFormat = "json";

    # Path to private key paired to the public key allowed to encrypt
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    # Define secrets
    secrets = {

    };
  };
}

# TODO: see https://github.com/Mic92/sops-nix?tab=readme-ov-file#emit-plain-file-for-yaml-and-json-formats