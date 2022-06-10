{
  description = "Luko's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
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
        stateVersion = "22.05";
        configuration = {
          imports = [ ./home.nix ];
        };
      };
    };

    nixosConfigurations = {
      nixvm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ./hardware-configuration-vm.nix ];
      };
      krypton = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ./hardware-configuration-krypton.nix ];
      };
      barium = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ./hardware-configuration-barium.nix ];
      };
    };
  };
}
