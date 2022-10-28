{ inputs, system, ... }:
with inputs;
{
  nixvm = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [ ./system/configuration.nix ./hardware-configuration/vm.nix ];
  };
  krypton = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [ ./system/configuration.nix ./hardware-configuration/krypton.nix ];
  };
  barium = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [ ./system/configuration.nix ./hardware-configuration/barium.nix ];
  };
}