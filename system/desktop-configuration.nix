# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
{
  imports = [
    ./modules/networking.nix
    ./modules/common.nix
  ];

  # Display manager
  services.xserver = {
    enable = true;
  };

  services.desktopManager = {
    plasma6 = {
      enable = true;
    };
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  hardware.opengl.enable = true;

  # Enable audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Installed system packages
  environment.systemPackages = with pkgs; [
    firefox
    xdg-desktop-portal
    xorg.xkill

    kdePackages.kdeconnect-kde
    kdePackages.krunner
    kdePackages.sddm-kcm
    kdePackages.ark
    kdePackages.plasma-browser-integration
    kdePackages.xdg-desktop-portal-kde
    kde-gtk-config
  ];

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint gutenprintBin hplip hplipWithPlugin ];
    browsedConf = ''
      BrowseRemoteProtocols none
      BrowseLocalProtocols none
      BrowseProtocols none
      BrowseDeny All
      BrowseInterval 100
      BrowseTimeout 300
      BrowsePoll nautilus.cosy.sbg.ac.at:443
    '';
  };
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  hardware.steam-hardware.enable = true;
  services.joycond.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "luko" ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };
  services.pcscd.enable = true;

  # Add fonts
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "SourceCodePro" "Hack" ]; })
      noto-fonts
      font-awesome
      roboto-mono
      dejavu_fonts
      xkcd-font
    ];
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # PlatformIO
  services.udev.packages = [ pkgs.platformio ];

  # System version, do not update here!
  system.stateVersion = "22.05";

}

