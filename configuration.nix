# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Enable flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Display manager
  services.xserver = {
    enable = true;

    desktopManager = {
      plasma5 = {
        enable = true;
      };
    };

    displayManager = {
      sddm.enable = true;
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

  # Define a user account. 
  users.users.luko = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # Installed system packages
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    firefox
    
    libsForQt5.kdeconnect-kde
    libsForQt5.krunner
    libsForQt5.sddm-kcm
    libsForQt5.ark
    libsForQt5.plasma-browser-integration
    kde-gtk-config

    openvpn
  ];

  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint gutenprintBin ];

  # SSHd
  services.openssh.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Firewall
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } { from = 8080; to = 8081; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

  networking.firewall.checkReversePath = "loose";

  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "lukovdm.github.beta.tailscale.net" ];


  # System version, do not update here!
  system.stateVersion = "22.05";

}

