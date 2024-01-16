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

  xenon = inputs.nixpkgs.lib.nixosSystem
    {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ../system/server-configuration.nix
        ../system/hardware-configurations/xenon.nix
      ];
    };

  live-usb = inputs.nixpkgs.lib.nixosSystem
    {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [

      ];
    };
}
