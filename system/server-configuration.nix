# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
{
  imports = [
    ./modules/networking.nix
    ./modules/mediarr.nix
    ./modules/common.nix
  ];

  hardware.opengl.enable = true;

  # System version, do not update here!
  system.stateVersion = "22.11";

}
