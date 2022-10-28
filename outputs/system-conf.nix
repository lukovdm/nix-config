{ inputs, system, ... }:
{
  nixvm = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [ 
      ../system/configuration.nix 
      ../system/hardware-configuration/vm.nix 
    ];
  };

  krypton = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [ 
      ../system/configuration.nix 
      ../system/hardware-configuration/krypton.nix
    ];
  };

  barium = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [ 
      ../system/configuration.nix 
      ../system/hardware-configuration/barium.nix
    ];
  };
}