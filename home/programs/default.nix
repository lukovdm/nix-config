{ config, pkgs, ... }:
{
  imports = [
    ./fish
    # Desktop environment
    ./kde
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Luko van der Maas";
      user.email = "me@luko.dev";
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    # Keep the pre-26.05 profile location; the new default is under
    # $XDG_CONFIG_HOME and would need ~/.mozilla/firefox moved by hand.
    configPath = ".mozilla/firefox";

    # Point home-manager at the profile directory that already exists, rather
    # than letting it create a fresh one named after the attribute.
    profiles.default = {
      path = "mib8vzmj.default-1781804192767";
      isDefault = true;
    };
  };

  # Theme that profile; without this stylix warns that it has no profile to
  # write to.
  stylix.targets.firefox.profileNames = [ "default" ];

  # Stylix can only theme Qt through qt5ct/qt6ct, and it detects the Plasma
  # session as platform "kde", where it does nothing but set these two values.
  # Set them directly and let plasma-manager own the Qt look.
  stylix.targets.qt.enable = false;
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
  };

  programs.htop = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
