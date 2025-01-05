{
  description = "Luko's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fish-bobthefish-theme = {
      url = github:gvolpe/theme-bobthefish;
      flake = false;
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
            "aspnetcore-runtime-wrapped-6.0.36"
          ];
        };
      };
    in
    {
      homeConfigurations = (
        import ./outputs/home-conf.nix {
          inherit inputs system overlay-unstable;
        }
      );

      nixosConfigurations = (
        import ./outputs/system-conf.nix {
          inherit inputs system overlay-unstable;
        }
      );
    };
}
