{ pkgs }: let pythonEnv = pkgs.python3.withPackages (ps: with ps; [ colorama ]); in
pkgs.writeScriptBin "air-hockey" ''
  #!${pkgs.bash}/bin/bash
  ${pythonEnv}/bin/python ./game/main.py "$@"
''
