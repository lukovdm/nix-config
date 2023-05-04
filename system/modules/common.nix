{ config, pkgs, inputs, ... }:
{

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
  boot.kernel.sysctl = { "kernel.sysrq" = 1; };

  # Set your time zone and locale.
  time.timeZone = "Europe/Amsterdam";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Define a user account. 
  users.users.luko = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "jellyfin" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # Installed system packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    git-crypt
    dig

    openvpn
    nixpkgs-fmt

    pinentry
    pinentry-qt
    gnupg
  ];

  programs.fish.enable = true;

  # SSHd
  services.openssh.enable = true;

  # SSH config
  programs.ssh.extraConfig = ''
    PubkeyAcceptedAlgorithms +ssh-rsa
    HostkeyAlgorithms +ssh-rsa
  '';

}
