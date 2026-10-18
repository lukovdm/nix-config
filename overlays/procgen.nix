final: prev: {
  # Epholys/procgen, an interactive L-System editor. Not in nixpkgs.
  procgen = prev.callPackage ../pkgs/procgen.nix { };
}
