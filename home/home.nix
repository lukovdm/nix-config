{ config, pkgs, ... }:
let 
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
      ;
  });
in
{
  imports = [
    ./programs
  ];
  
  home = {
    username = "luko";
    homeDirectory = "/home/luko";

    # Home manager version
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "vim";
    };

    # Install home packages
    packages = with pkgs; [
      spotify
      vlc

      # Socials
      zoom-us
      slack
      mattermost-desktop
      thunderbird
      discord

      # Creative stuff
      libreoffice
      gimp
      inkscape
      openscad
      super-slicer
      audacity

      # Programming stuff
      coq
      zotero
      jetbrains.pycharm-professional
      jetbrains.webstorm
      jetbrains.clion
      nodePackages.npm
      nodejs
      tex

      # KDE stuff
      libsForQt5.kate
      libsForQt5.kdenlive

      # Terminal stuff
      fishPlugins.pisces
      any-nix-shell
      fzf
      exa
      prettyping
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
