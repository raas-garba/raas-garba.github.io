{
  description = "Raas Garba";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.legacyPackages.${system};
      {
        devShells.default = mkShell {
          name = "mkdocs";
          venvDir = "./.venv";
          buildInputs = with python312Packages; [
            python312
            ruff
            build
            wheel
            mkdocs-material
            venvShellHook
            pyyaml
          ];
        };

        apps.default.type = "app";
        apps.default.program = "${python312.withPackages (p: with p; [ mkdocs-material ])}/bin/mkdocs";
      }
    );
}
