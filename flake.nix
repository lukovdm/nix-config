{
  description = "Luko's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  in {
    homeConfigurations = {
      luko = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "luko";
        homeDirectory = "/home/luko";
        stateVersion = "21.11";
        configuration = {
          imports = [ ./home.nix ];
        };
      };
    };

    nixosConfigurations = {
      nixvm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };
    };
  };
}
