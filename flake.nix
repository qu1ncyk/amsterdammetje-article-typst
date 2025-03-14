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
        dependencies = [pkgs.typst pkgs.newcomputermodern];
      in {
        # nix develop
        devShells.default = pkgs.mkShell {
          shellHook = ''
            export TYPST_FONT_PATHS=${pkgs.newcomputermodern}
          '';
          buildInputs = dependencies;
        };

        # nix develop .#compile
        # Using `devShells` as a hack instead of `packages` because the
        # compilation needs internet
        devShells.compile = pkgs.mkShell {
          buildInputs = dependencies;
          shellHook = ''
            exec typst compile main.typ --font-path ${pkgs.newcomputermodern}
          '';
        };

        # nix develop .#watch
        devShells.watch = pkgs.mkShell {
          buildInputs = dependencies;
          shellHook = ''
            exec typst watch main.typ --font-path ${pkgs.newcomputermodern}
          '';
        };
      }
    );
}
