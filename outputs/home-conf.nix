{ inputs, system, overlay-unstable, ... }:

with inputs;
let
  fishOverlay = f: p: {
    inherit fish-bobthefish-theme;
  };

  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;

    overlays = [
      overlay-unstable
      fishOverlay
      (import ../overlays/android-studio.nix)
      (final: prev: {
        nwjs = prev.nwjs.overrideAttrs {
          version = "0.84.0";
          src = prev.fetchurl {
            url = "https://dl.nwjs.io/v0.84.0/nwjs-v0.84.0-linux-x64.tar.gz";
            hash = "sha256-VIygMzCPTKzLr47bG1DYy/zj0OxsjGcms0G1BkI/TEI=";
          };
        };
      })
    ];
  };

  mkHome = (
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;
      modules = [
        ../home/home.nix
        inputs.plasma-manager.homeModules.plasma-manager
      ];
    }
  );
in
{
  luko = mkHome;
}
