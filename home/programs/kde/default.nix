{ pkgs, ... }:
{
  imports = [ ../plasma.nix ];

  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.kdenlive
    kdePackages.konsole
    kdePackages.yakuake
  ];
}
