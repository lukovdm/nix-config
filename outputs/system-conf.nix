{ inputs, system, ... }:
{
  barium = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/desktop-configuration.nix
      ../system/hardware-configurations/barium.nix
    ];
  };

  nixvm = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/desktop-configuration.nix
      ../system/hardware-configurations/vm.nix
    ];
  };

  krypton = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/desktop-configuration.nix
      ../system/hardware-configurations/krypton.nix
    ];
  };
}
