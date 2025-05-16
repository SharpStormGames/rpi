{ inputs, lib, modulesPath, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    python3
    raspberrypi-eeprom
    (import ./game.nix { inherit pkgs; })
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

  networking = {
    useNetworkd = true;
    networkmanager = {
      enable = true;
      plugins = lib.mkForce [];
    };
    useDHCP = false;
    hostName = "rpi5";
    firewall.allowedTCPPorts = [ 22 ];
  };

  nix.settings.trusted-users = [ "nixos" ];
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
  };

  systemd.network.networks."10-eth0" = {
    matchConfig.Name = "eth0";
    networkConfig = {
      Address = "10.42.0.2/24";
      Gateway = "10.42.0.1";
      DNS = "8.8.8.8";
    };
  };

  system.stateVersion = lib.mkForce "24.11";

  time.timeZone = "Australia/Sydney";

  users.users = {
    nixos = {
      extraGroups = [ "networkmanager" "video" "wheel" ];
      initialHashedPassword = "";
      isNormalUser = true;
      #openssh.authorizedKeys.keys = [ "" ];
    };
    root = {
      initialHashedPassword = "";
      #openssh.authorizedKeys.keys = [ "" ];
    };
  };
}
