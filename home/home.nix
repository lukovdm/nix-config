{ config, pkgs, lib, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
      ;
  });

  pycharm-professional = pkgs.unstable.jetbrains.pycharm-professional.overrideAttrs
    (attrs: {
      buildInputs = (attrs.buildInputs or [ ]) ++ (with pkgs; [
        stdenv.cc.cc.lib
        libsecret
        e2fsprogs
        libnotify
        linux-pam
        audit
      ]);

      # NOTE(Sem Mulder): Hacky way to disable LD_LIBRARY_PATH.
      installPhase = lib.replaceStrings [ "LD_LIBRARY_PATH" ] [ "WRONG_LD_LIBRARY_PATH" ] attrs.installPhase;
    });

  webstorm = pkgs.unstable.jetbrains.webstorm.overrideAttrs
    (attrs: {
      buildInputs = (attrs.buildInputs or [ ]) ++ (with pkgs; [
        stdenv.cc.cc.lib
        libsecret
        e2fsprogs
        libnotify
        linux-pam
        audit
      ]);

      # NOTE(Sem Mulder): Hacky way to disable LD_LIBRARY_PATH.
      installPhase = lib.replaceStrings [ "LD_LIBRARY_PATH" ] [ "WRONG_LD_LIBRARY_PATH" ] attrs.installPhase;
    });

  clion = pkgs.unstable.jetbrains.clion.overrideAttrs
    (attrs: {
      buildInputs = (attrs.buildInputs or [ ]) ++ (with pkgs; [
        stdenv.cc.cc.lib
        libsecret
        e2fsprogs
        libnotify
        linux-pam
        audit
      ]);

      # NOTE(Sem Mulder): Hacky way to disable LD_LIBRARY_PATH.
      installPhase = lib.replaceStrings [ "LD_LIBRARY_PATH" ] [ "WRONG_LD_LIBRARY_PATH" ] attrs.installPhase;
    });
in
{
  imports = [
    ./programs
    ./services
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
      calibre
      gnucash

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
      unstable.prusa-slicer
      audacity
      blender
      darktable

      # Programming stuff
      coq
      unstable.zotero
      pycharm-professional
      webstorm
      clion
      nodePackages.npm
      nodejs
      tex
      autokey
      ltex-ls

      # KDE stuff
      libsForQt5.kate
      libsForQt5.kdenlive
      libsForQt5.yakuake
      libsForQt5.krohnkite

      # Terminal stuff
      fishPlugins.pisces
      fishPlugins.foreign-env
      any-nix-shell
      fzf
      exa
      prettyping
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
