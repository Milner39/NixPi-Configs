{ inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {

    # Path to private key paired to the public key allowed to decrypt
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    # Define secrets
    secrets = {
      "host/wireless" = {
        sopsFile = ./host/wireless.env;
        key = "";
        format = "env";
      };

      "users/finnm/hashedPasswd" = {
        sopsFile = ./users/finnm/hashedPasswd.txt;
        format = "binary";
        neededForUsers = true;
      };
      "users/finnm/sshKeys/pc" = {
        sopsFile = ./users/finnm/sshKeys/pc.txt;
        format = "binary";
        neededForUsers = true;
      };
    };
  };
}