{ inputs, nixpkgs }: let
  pythonEnv = nixpkgs.python3.withPackages (ps: with ps; [
    colorama
    gpiozero
    pyserial
    inputs.mypkgs.packages.aarch64-linux.rpi-lgpio
  ]);
in
  nixpkgs.writeScriptBin "air-hockey" ''
    #!${nixpkgs.bash}/bin/bash
    ${pythonEnv}/bin/python ${./game}/main.py "$@"
  ''
