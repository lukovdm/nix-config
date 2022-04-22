{ pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}