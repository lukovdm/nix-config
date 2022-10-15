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
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # Installed system packages
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    firefox
    xorg.xkill
    
    libsForQt5.kdeconnect-kde
    libsForQt5.krunner
    libsForQt5.sddm-kcm
    libsForQt5.ark
    libsForQt5.plasma-browser-integration
    kde-gtk-config

    openvpn
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

  # SSHd
  services.openssh.enable = true;

  # SSH config
  programs.ssh.extraConfig = ''
    PubkeyAcceptedAlgorithms +ssh-rsa
    HostkeyAlgorithms +ssh-rsa
  '';

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  virtualisation.docker.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Firewall
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } { from = 8000; to = 8443; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedTCPPorts = [ 8010 ]; # vlc chromecast

  networking.firewall.checkReversePath = "loose";

  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "lukovdm.github.beta.tailscale.net" ];


  # System version, do not update here!
  system.stateVersion = "22.05";

}

