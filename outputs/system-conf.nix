{ inputs, system, overlay-unstable, ... }:
with inputs;
let
  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "aspnetcore-runtime-6.0.36"
      "broadcom-sta-6.30.223.271-59-6.12.63"
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
      inputs.agenix.nixosModules.default
      inputs.niri.nixosModules.niri
      inputs.stylix.nixosModules.stylix
      ../system/desktop-configuration.nix
      ../system/hardware-configurations/barium.nix
    ];
  };

  # nixvm = inputs.nixpkgs.lib.nixosSystem {
  #   inherit system;
  #   specialArgs = { inherit inputs; };
  #   modules = [
  #     inputs.agenix.nixosModules.default
  #     ../system/desktop-configuration.nix
  #     ../system/hardware-configurations/vm.nix
  #   ];
  # };

  krypton = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    specialArgs = { inherit inputs; };
    modules = [
      inputs.agenix.nixosModules.default
      inputs.bbg-mm.nixosModules.bgg-mm
      inputs.aimc.nixosModules.default
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
  #       inputs.agenix.nixosModules.default
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
