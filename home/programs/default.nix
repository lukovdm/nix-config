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
    userName = "Luko van der Maas";
    userEmail = "me@luko.dev";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-copilot ];
  };

  programs.firefox = {
    enable = true;
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
