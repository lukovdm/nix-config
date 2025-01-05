{ inputs, system, overlay-unstable, ... }:
with inputs;
let
  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "aspnetcore-runtime-6.0.36"
    ];

    overlays = [
      overlay-unstable
    ];
  };
in
{
  barium = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/desktop-configuration.nix
      ../system/hardware-configurations/barium.nix
    ];
  };

  # nixvm = inputs.nixpkgs.lib.nixosSystem {
  #   inherit system;
  #   specialArgs = { inherit inputs; };
  #   modules = [
  #     ../system/desktop-configuration.nix
  #     ../system/hardware-configurations/vm.nix
  #   ];
  # };

  krypton = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/server-configuration.nix
      ../system/hardware-configurations/krypton.nix
    ];

  };

  # xenon = inputs.nixpkgs.lib.nixosSystem
  #   {
  #     inherit system;
  #     inherit pkgs;
  #     specialArgs = { inherit inputs; };
  #     modules = [
  #       ../system/server-configuration.nix
  #       ../system/hardware-configurations/xenon.nix
  #     ];
  #   };

  # live-usb = inputs.nixpkgs.lib.nixosSystem
  #   {
  #     inherit system;
  #     specialArgs = { inherit inputs; };
  #     modules = [

  #     ];
  #   };
}
