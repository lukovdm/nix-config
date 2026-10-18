{ inputs, system, overlay-unstable, ... }:
with inputs;
let
  fishOverlay = f: p: {
    inherit fish-bobthefish-theme;
  };

  # Matched by name, not "<name>-<version>": broadcom-sta (krypton's wifi
  # driver) carries the kernel release in its version, so a pinned entry
  # breaks at every kernel bump. Defining this predicate replaces
  # `permittedInsecurePackages` entirely.
  allowInsecurePredicate =
    pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      "broadcom-sta"
      "dotnet-sdk"
      "aspnetcore-runtime"
    ];

  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    config.allowInsecurePredicate = allowInsecurePredicate;

    overlays = [
      overlay-unstable
    ];
  };

  # Desktop pkgs with extra overlays for home-manager (fish theme, zen-browser, etc.)
  desktopPkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    config.android_sdk.accept_license = true;
    config.allowInsecurePredicate = allowInsecurePredicate;

    overlays = [
      overlay-unstable
      fishOverlay
      (import ../overlays/android-studio.nix)
      (import ../overlays/procgen.nix)
      (final: prev: {
        # zen-browser upstream re-published the 1.23.3b release assets about
        # 13h after zen-browser-flake's bot pinned them, so the flake's hash
        # no longer matches the tarball that URL now serves. Drop this
        # override once the flake moves to a newer version.
        zen-browser =
          let
            zen = inputs.zen-browser.packages.${system};
          in
          zen.default.override {
            zen-browser-unwrapped = zen.zen-browser-unwrapped.override {
              hash = "sha256-uyBF0+IWVNQP6EElAJLurf0sH8gx7vtQkiJ3PIvcoUk=";
            };
          };
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
        home-manager.backupFileExtension = "hm-backup";
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
