{ config, pkgs, ... }:
let tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
      ;
  });
in
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
    zoom-us
    slack

    gimp
    inkscape
    openscad
    super-slicer

    coq
    zotero
    jetbrains.pycharm-professional
    jetbrains.webstorm
    jetbrains.clion
    nodePackages.npm
    nodejs
    postman
    tex

    libsForQt5.kate
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
