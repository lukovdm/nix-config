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
      inherit system pkgs;
      username = "luko";
      homeDirectory = "/home/luko";
      stateVersion = "21.11";
      configuration = {
        imports = [ ../home/home.nix ];
      };
    }
  );
in 
{
  luko = mkHome;
}
