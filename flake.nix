{
  description = "Amsterdammetje Article";

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
            # https://github.com/typst/typst/issues/5282
            unset SOURCE_DATE_EPOCH
          '';
          buildInputs = dependencies;
        };

        # nix develop .#compile
        # Using `devShells` as a hack instead of `packages` because the
        # compilation needs internet
        devShells.compile = pkgs.mkShell {
          buildInputs = dependencies;
          shellHook = ''
            # https://github.com/typst/typst/issues/5282
            unset SOURCE_DATE_EPOCH
            exec typst compile template/main.typ --font-path ${pkgs.newcomputermodern}
          '';
        };

        # nix develop .#render-thumbnail
        devShells.render-thumbnail = pkgs.mkShell {
          buildInputs = dependencies ++ [pkgs.oxipng];
          shellHook = ''
            typst compile template/main.typ thumbnail.png --format png --font-path ${pkgs.newcomputermodern}
            exec oxipng -o max -s thumbnail.png
          '';
        };

        # nix develop .#render-docs
        devShells.render-docs = pkgs.mkShell {
          buildInputs = dependencies;
          shellHook = ''
            exec typst compile docs.typ --font-path ${pkgs.newcomputermodern}
          '';
        };

        # nix develop .#watch
        devShells.watch = pkgs.mkShell {
          buildInputs = dependencies;
          shellHook = ''
            # https://github.com/typst/typst/issues/5282
            unset SOURCE_DATE_EPOCH
            exec typst watch template/main.typ --font-path ${pkgs.newcomputermodern}
          '';
        };
      }
    );
}
