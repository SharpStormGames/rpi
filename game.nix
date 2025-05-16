{ nixpkgs }: let pythonEnv = nixpkgs.python3.withPackages (ps: with ps; [ colorama ]); in
nixpkgs.writeScriptBin "air-hockey" ''
  #!${nixpkgs.bash}/bin/bash
  ${pythonEnv}/bin/python ./game/main.py "$@"
''
