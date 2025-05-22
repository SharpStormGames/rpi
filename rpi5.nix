{ inputs, lib, modulesPath, nixpkgs, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    git
    python3
    raspberrypi-eeprom
    rshell
    neovim
    (import ./game.nix { inherit inputs nixpkgs; })
  ];

  imports = with inputs.nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.display-vc4
    trusted-nix-caches
  ] ++ [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [ "noatime" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=1min" ];
    };
  };

  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    hostName = "rpi5";
    interfaces.end0.useDHCP = true;
    networkmanager = {
      enable = true;
      plugins = lib.mkForce [];
      ensureProfiles.profiles.PiSSH = {
        connection = {
          id = "PiSSH";
          interface-name = "end0";
          type = "ethernet";
          uuid = "5e0a9fb9-774c-4d89-bc76-e01519143fb4";
        };
        ipv4 = {
          address1 = "10.42.0.2/24";
          dns = "10.42.0.10;";
          gateway = "10.42.0.1";
          method = "manual";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
      };
    };
    useDHCP = false;
  };

  nix = {
    extraOptions = "warn-dirty = false";
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
      extra-trusted-public-keys = [ "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=" ];
      trusted-users = [ "root" "nixos" ];
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  security = {
    polkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  services = {
    getty.autologinUser = "nixos";
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
    udev.packages = [ pkgs.raspberrypi-udev-rules ];
  };

  system = {
    activationScripts.copyFileToHome.text = ''
      mkdir -p /home/nixos/.zed_server
      rm /home/nixos/.zed_server/* -f
      cp -r ${nixpkgs.zed-editor.remote_server}/bin/* /home/nixos/.zed_server/
    '';
    stateVersion = lib.mkForce "24.11";
  };

  systemd.tmpfiles.packages = [ pkgs.raspberrypi-udev-rules ];

  time.timeZone = "Australia/Sydney";

  users.users = {
    nixos = {
      extraGroups = [ "networkmanager" "video" "wheel" "dialout" "gpio" ];
      initialHashedPassword = "nixos";
      isNormalUser = true;
    };
    root.initialHashedPassword = "root";
  };
}
