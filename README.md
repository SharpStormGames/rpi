# rpi

Repository for Pi 5 NixOS Configuration and game code.

## Installing NixOS

Set NixOS Option on host machine and rebuild
```nix
boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
```

Build an sdImage with the configuration
```sh
nix build github:sharpstormgames/rpi#nixosConfigurations.rpi5-installer.config.system.build.sdImage
```

Flash the image to an SD Card with the Raspberry Pi Imager.

## Setting up SSH over USB-Ethernet with NetworkManager

On Host System, run
```sh
nmcli connection add type ethernet con-name PiSSH ifname <interface> ipv4.method shared
```

Replace interface with the ethernet interface, (use `ip a` to see it)

Ping the Pi
```sh
ping 10.42.0.2
```

If a response is seen, SSH into the Pi
```sh
ssh nixos@10.42.0.2
```
