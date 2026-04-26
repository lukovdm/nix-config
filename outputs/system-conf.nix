{ inputs, system, overlay-unstable, ... }:
with inputs;
let
  fishOverlay = f: p: {
    inherit fish-bobthefish-theme;
  };

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

  # Desktop pkgs with extra overlays for home-manager (fish theme, zen-browser, etc.)
  desktopPkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    config.android_sdk.accept_license = true;
    config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "aspnetcore-runtime-6.0.36"
      "broadcom-sta-6.30.223.271-59-6.12.63"
    ];

    overlays = [
      overlay-unstable
      fishOverlay
      (import ../overlays/android-studio.nix)
      (final: prev: {
        zen-browser = inputs.zen-browser.packages.${system}.default;
        nwjs = prev.nwjs.overrideAttrs {
          version = "0.84.0";
          src = prev.fetchurl {
            url = "https://dl.nwjs.io/v0.84.0/nwjs-v0.84.0-linux-x64.tar.gz";
            hash = "sha256-VIygMzCPTKzLr47bG1DYy/zj0OxsjGcms0G1BkI/TEI=";
          };
        };
      })
    ];
  };
in
{
  barium = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    pkgs = desktopPkgs;
    specialArgs = { inherit inputs; };
    modules = [
      inputs.agenix.nixosModules.default
      inputs.niri.nixosModules.niri
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.luko = import ../home/home.nix;
        home-manager.sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
          # niri + stylix home modules are auto-imported by their NixOS modules
        ];
      }
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
