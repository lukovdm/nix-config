{
  description = "Luko's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
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
            "broadcom-sta-6.30.223.271-57-6.12.44"
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
