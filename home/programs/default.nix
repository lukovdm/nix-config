{ config, pkgs, ... }:
{
  imports = [
    ./fish
    # Desktop environments (both installed, pick session at SDDM login)
    ./kde
    ./niri
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
