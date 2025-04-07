{ sops-nix, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops = {

    # Path to private key paired to the public key allowed to decrypt
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    defaultSopsFormat = "json";

    # Define secrets
    secrets = {
      "host.json" = {
        sopsFile = ./host.json;
        key = "";
      };
      "finnm.json" = {
        sopsFile = ./finnm.json;
        key = "";
      };
    };
  };
}

# NOTE: see https://github.com/Mic92/sops-nix?tab=readme-ov-file#emit-plain-file-for-yaml-and-json-formats