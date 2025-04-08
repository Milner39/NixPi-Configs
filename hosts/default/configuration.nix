{ config, pkgs, nixos-hardware, ... }:

let
  secrets = config.sops.secrets;
in
{
  imports = [
    # Configures the kernel and bootloader
    # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/3/default.nix
    "${nixos-hardware}/raspberry-pi/3"

    ./hardware-configuration.nix
  ];



  # === Build ===

  # Disable building docs
  documentation.nixos.enable = false;

  # === Build ===



  # === Bootloader ===

  # Wait 3 seconds before booting
  boot.loader.timeout = 3;

  # === Bootloader ===



  # === File Systems ===

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # === File Systems ===



  # === Hardware ===

  hardware = {
    # Enable third-party firmware (drivers)
    enableRedistributableFirmware = true;
  };

  # === Hardware ===



  # === Performance ===

  # Use RAM as compressed Swap space
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # === Performance ===



  # === Networking ===

  networking = {
    hostName = "NixPi";
    useDHCP = true;

    # Configure WiFi
    wireless = {
      enable = true;
      secretsFile = secrets."host/wireless".path;
      networks = {
        "ext:SSID" = {
          pskRaw = "ext:PSK";
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


  # === Users ===

  users.users.finnm = {
    # Automatically set various options like home directory etc.
    isNormalUser = true;

    # Add to groups to elevate permissions
    extraGroups = [ "wheel" ];

    # Login Methods
    hashedPasswordFile = secrets."users/finnm/hashedPasswd".path;
    openssh.authorizedKeys.keyFiles = [
      secrets."users/finnm/sshKeys/pc".path
    ];
  };

  # === Users ===



  # === Nix ===

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";

  # === Nix ===



  # === Environment ===

  # Add globally available packages
  environment.systemPackages = with pkgs; [
    git
    ssh-to-age
  ];

  # === Environment ===
}