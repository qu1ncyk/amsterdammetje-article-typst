{
  description = "Typst document";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        dependencies = [pkgs.typst pkgs.cm_unicode];
      in {
        # nix develop
        devShells.default = pkgs.mkShell {
          buildInputs = dependencies;
        };

        # nix develop .#compile
        # Using `devShells` as a hack instead of `packages` because the
        # compilation needs internet
        devShells.compile = pkgs.mkShell {
          buildInputs = dependencies;
          shellHook = "typst compile main.typ; exit";
        };

        # nix develop .#watch
        devShells.watch = pkgs.mkShell {
          buildInputs = dependencies;
          shellHook = "typst watch main.typ";
        };
      }
    );
}
