{
  description = "Raas Garba";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.legacyPackages.${system};
      let
        devShells.default = mkShell {
          name = "mkdocs";
          venvDir = "./.venv";
          buildInputs = with python3Packages; [
            python3
            ruff
            build
            wheel
            mkdocs-material
            mkdocs-awesome-pages-plugin
            venvShellHook
            pyyaml
          ];
        };

        mkdocs = python3.withPackages (p: with p; [ mkdocs-material mkdocs-awesome-pages-plugin ]);

        packages.default = mkdocs;
        apps.default.type = "app";
        apps.default.program = "${mkdocs}/bin/mkdocs";

      in {
        inherit devShells packages apps;
      }
    );
}
