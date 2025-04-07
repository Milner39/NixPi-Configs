{ lib, pkgs, ... }:

let
  utils = import ./utils;
  
  secrets = {
    host = utils.parseJsonFile /run/secrets/hostJson;
    finnm = utils.parseJsonFile /run/secrets-for-users/finnmJson;
  };
in
{
  # === Build ===

  # Disable building docs
  documentation.nixos.enable = false;

  # === Build ===



  # === Bootloader ===

  # Wait 3 seconds before booting
  boot.loader.timeout = 3;

  # NOTE: 
    # Most bootloader settings are set by the nixos-hardware package,
    # see `./flake.nix`.

  # === Bootloader ===



  # === Hardware ===

  hardware = {
    # Enable third-party firmware (drivers)
    enableRedistributableFirmware = true;

    # Or disable and add firmware manually.
    # Some people like to add firmware explicitly but I don't see the point.
    # enableRedistributableFirmware = lib.mkForce false;
    # firmware = [
    #   # Wifi & Bluetooth
    #   pkgs.raspberrypiWirelessFirmware
    # ];
  };

  # === Hardware ===



  # === Networking ===

  networking = {
    hostName = "NixPi";
    useDHCP = true;

    # Configure WiFi
    wireless = {
      enable = true;
      networks = {
        "${secrets.host.wifi.ssid}" = {
          psk = secrets.host.wifi.psk;
        };
      };
    };
  };

  # OpenSSH options
  services.sshd = {
    enable = true;

    # "settings" option does not exist error even though it exists in this file
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/networking/ssh/sshd.nix#L442
    # But it does not exist when searching in Nix options
    # https://search.nixos.org/options?channel=24.11&show=services.sshd
    # settings = {
    #   # Do not allow password auth, only key-based
    #   PasswordAuthentication = false;
    # };
  };

  # === Networking ===


  # === Users (edit this for your own setup) ===

  users.users.finnm = {
    # Automatically set various options like home directory etc.
    # https://search.nixos.org/options?show=users.users.%3Cname%3E.isNormalUser
    isNormalUser = true;

    # Add to groups to elevate permissions
    extraGroups = ["wheel"];

    # Login Methods
    hashedPassword = secrets.finnm.auth.hashedPasswd;
    openssh.authorizedKeys.keys = secrets.finnm.auth.sshKeys;
  };

  # === Users ===



  # === Nix ===

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";

  # === Nix ===



  # === Environment ===

  # Add globally available packages
  environment.systemPackages = with pkgs; [
    # For sops secrets
    ssh-to-age
  ];

  # === Environment ===
}