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

  # Install home packages
  home.packages = with pkgs; [
    spotify
    thunderbird
    libreoffice
    discord
    vlc
    _1password-gui

    gimp
    inkscape
    openscad
    super-slicer

    coq
    zotero
    jetbrains.pycharm-professional
    jetbrains.webstorm
    nodePackages.npm
    nodejs
    postman
    zoom-us
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Luko van der Maas";
    userEmail = "me@luko.dev";
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
