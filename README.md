# SeaDexArr Nix flake

This repository contains a Nix flake for
[SeaDexArr](https://github.com/bbtufty/seadexarr).

## Usage

Add this repo to your flake inputs, and add the module to your NixOS
configuration:

```nix
{
inputs = {
        # ... other inputs such as nixpkgs
        seadexarr.url = "github:TheColorman/seadexarr-nix-flake";
        # Optionally follow your existing nixpkgs
        seadexarr.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {nixpkgs, seadexarr, ...}: {
        nixosConfigurations.my-system = nixpkgs.lib.nixosSystem {
            modules = [
                ./configuration.nix
                seadexarr.nixosModules.default
            ];
        };
    }
}
```

You can now configure SeaDexArr. Here is a list of all configuration options and
their defaults:

```nix
{
    services.seadexarr = {
        # No instances are enabled by default, but you can add as many as you want here.
        my-instance = {
            enable = true; # Default: false
            name = "my-instance"; # Default: same as instance attribute name
            package = <package>; # Default: seadexarr.packages.<system>.seadexarr

            # Settings written to `config.json`. For all options, see
            # - https://github.com/bbtufty/seadexarr?tab=readme-ov-file#config
            settings = {};

            # Path to a YAML file that will be merged with the "settings" option, suitable for storing secrets.
            settingsFile = "/run/secrets/seadexarr.yaml";
        };
    };
}
```

For more details on every option, see [./module.nix](./module.nix).
