{
  description = "Nix package for SeadDexArr";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      {
        lib,
        withSystem,
        self,
        ...
      }:
      {
        imports = [
          ./packages
          ./module.nix
        ];

        systems = lib.systems.flakeExposed;

        flake.overlays = {
          seadexarr =
            _final: prev:
            withSystem prev.stdenv.hostPlatform.system (
              { self', ... }:
              {
                inherit (self'.packages) seadexarr;
              }
            );
          default = self.overlays.seadexarr;
        };

      }
    );
}
