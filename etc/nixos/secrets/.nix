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
      hostJson = {
        sopsFile = ./host.json;
        key = "";
      };
      finnmJson = {
        sopsFile = ./finnm.json;
        key = "";
        neededForUsers = true;
      };
    };
  };
}

# NOTE: see https://github.com/Mic92/sops-nix?tab=readme-ov-file#emit-plain-file-for-yaml-and-json-formats