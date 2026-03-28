{
  perSystem =
    { self', pkgs, ... }:
    {
      packages = {
        seadexarr = pkgs.callPackage ./seadexarr.nix {
          extraPackages = {
            inherit (self'.packages)
              arrapi
              discordwebhook
              pynyaa
              seadex
              ;
          };
        };
        default = self'.packages.seadexarr;

        # Python modules
        arrapi = pkgs.python3Packages.callPackage ./python/arrapi.nix { };
        atomicwriter = pkgs.python3Packages.callPackage ./python/atomicwriter.nix { };
        discordwebhook = pkgs.python3Packages.callPackage ./python/discordwebhook.nix { };
        pynyaa = pkgs.python3Packages.callPackage ./python/pynyaa.nix { };
        seadex = pkgs.python3Packages.callPackage ./python/seadex.nix {
          inherit (self'.packages) atomicwriter;
        };
      };

    };

}
