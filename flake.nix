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
            mkdocs-material
            mkdocs-awesome-pages-plugin
            python3
            ruff
            build
            wheel
            venvShellHook
          ];
        };

        mkdocs = python3.withPackages (p: with p; [
          mkdocs-material
          mkdocs-awesome-pages-plugin
        ]);

        serve-docs = pkgs.writeShellScriptBin "serve-docs" ''
          exec "${mkdocs}/bin/mkdocs" serve
        '';

        packages.default = serve-docs;
        apps.default.type = "app";
        apps.default.program = "${packages.default}/bin/serve-docs";

      in {
        inherit devShells packages apps;
      }
    );
}
