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

On the Pi, run
```sh
nmcli connection add type ethernet con-name "PiSSH" ifname end0 ipv4.method manual ipv4.addresses 10.42.0.2/24 ipv4.gateway 10.42.0.1 ipv4.dns 10.42.0.10
nmcli con up PiSSH
```

Check that the static ip is correct (use `ip addr show end0`)

Ping the host (use `ping 10.42.0.1`)

If a response is seen, SSH into the Pi
```sh
ssh nixos@10.42.0.2
```
