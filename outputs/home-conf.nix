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
    ];
  };

  mkHome = (
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;
      modules = [
        ../home/home.nix
        ];
    }
  );
in 
{
  luko = mkHome;
}
