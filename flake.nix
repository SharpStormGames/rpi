{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nixos-images = { url = "github:nvmd/nixos-images/sdimage-installer"; inputs.nixos-stable.follows = "nixpkgs"; inputs.nixos-unstable.follows = "nixpkgs"; };
  };

  nixConfig = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [ "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=" ];
  };

  outputs = { self, nixos-images, nixos-raspberrypi, ... }@inputs: let
    nixpkgs = import inputs.nixpkgs { system = "aarch64-linux"; }; game = nixpkgs.callPackage ./game.nix { inherit nixpkgs; };
  in {
    packages.aarch64-linux.default = game;
    nixosConfigurations = {
      rpi5 = nixos-raspberrypi.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs nixos-raspberrypi nixpkgs; };
        modules = [ ./rpi5.nix ];
      };
      rpi5-installer = nixos-raspberrypi.lib.nixosInstaller {
        system = "aarch64-linux";
        specialArgs = { inherit inputs nixos-raspberrypi nixpkgs; };
        modules = [
          ./rpi5.nix
          nixos-images.nixosModules.sdimage-installer
          ({ modulesPath, ... }: { disabledModules = [(modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")]; })
        ];
      };
    };
  };
}
