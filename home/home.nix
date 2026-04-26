{ config, pkgs, lib, ... }:
let
  tex = (pkgs.unstable.texlive.combine {
    inherit (pkgs.unstable.texlive) scheme-full
      ;
  });

  pycharm = pkgs.unstable.jetbrains.pycharm.overrideAttrs
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

  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.allowUnfree = true;

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
      prismlauncher
      tor-browser
      zen-browser
      betaflight-configurator
      ffmpeg
      moonlight-qt

      # Socials
      zoom-us
      slack
      mattermost-desktop
      thunderbird
      discord
      unstable.signal-desktop

      # Creative stuff
      libreoffice
      gimp
      inkscape
      openscad
      pkgs.unstable.orca-slicer
      pkgs.unstable.bambu-studio
      audacity
      blender
      darktable
      obsidian
      sdrpp

      # Programming stuff
      coq
      unstable.zotero
      pycharm
      webstorm
      clion
      nodePackages.npm
      nodejs
      tex
      autokey
      pkgs.unstable.netlogo
      github-copilot-cli
      unstable.claude-code
      android-studio
      python3

      # Terminal stuff
      fishPlugins.pisces
      fishPlugins.foreign-env
      any-nix-shell
      fzf
      eza
      prettyping
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
