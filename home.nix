{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "luko";
  home.homeDirectory = "/home/luko";

  # Home manager version
  home.stateVersion = "21.11";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Luko van der Maas";
    userEmail = "nixvm@luko.dev";
  };

  programs.firefox = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
  };

  programs.htop = {
    enable = true;
  }; 
}
