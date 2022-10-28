{ inputs, system, ... }:

with inputs;
let 
  fishOverlay = f: p: {
    inherit fish-bobthefish-theme;
  };

  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;

    overlays = [
      fishOverlay
    ];
  };

  imports = [
    ../home/home.nix
  ];

  mkHome = (
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;

      modules = [{ inherit imports; }];
    }
  );
in 
{
  luko = mkHome;
}
