# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
{
  imports = [
    ./modules/networking.nix
  ];

  # Enable flakes
  nix = {
    # Flakes settings
    package = pkgs.nixVersions.stable;
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;

      # Enable nix flake command
      experimental-features = [ "nix-command" "flakes" ];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone and locale.
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  # Display manager
  services.xserver = {
    enable = true;

    desktopManager = {
      plasma5 = {
        enable = true;
        useQtScaling = true;
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
    extraGroups = [ "wheel" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

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

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "luko" ];
    gid = 5000;
  };

  # Add fonts
  fonts = pkgs.lib.mkForce {
    fontconfig.defaultFonts = {
        monospace = [ "Fira Code Nerd Font" "Noto Sans Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };

    fonts = with pkgs; [
      nerdfonts 
      noto-fonts 
      hack-font
      font-awesome
    ];
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # System version, do not update here!
  system.stateVersion = "22.05";

}
