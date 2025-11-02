{
  description = "Raas Garba";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    with nixpkgs.legacyPackages.${system};
    let
      devShells.default = mkShell {
        name = "mkdocs";
        venvDir = "./.venv";
        buildInputs = with python3Packages; [
          pkgs.ruff
          pkgs.uv
          mkdocs-material
          mkdocs-awesome-nav
          python
          venvShellHook
        ];
      };

      mkdocs = python3.withPackages (p: with p; [
        mkdocs-material
        mkdocs-awesome-nav
      ]);

      packages.default = pkgs.writeShellScriptBin "serve-docs" ''
        exec "${mkdocs}/bin/mkdocs" serve
      '';

      apps.default.type = "app";
      apps.default.program = "${packages.default}/bin/serve-docs";
      apps.mkdocs.type = "app";
      apps.mkdocs.program = "${mkdocs}/bin/mkdocs";

    in {
      inherit devShells packages apps;
    }
  );
}
