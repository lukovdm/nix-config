{ config, pkgs, ... }:
let tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
      ;
  });
in
{
  nixpkgs.overlays = [ 
    (self: super: {
      slack = super.slack.override {
        nss = super.nss_latest;
      };
    }) 
  ];

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
    audacity

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
    libsForQt5.kdenlive

    fishPlugins.pisces
    fzf
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    functions = {
      __fish_command_not_found_handler = {
        body = "/nix/store/yg6vligw4m5mw13pywd3yrvly3ldblnx-command-not-found/bin/command-not-found $argv[1]";
        onEvent = "fish_command_not_found";
      };
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      haskellEnv = "nix-shell -p \"haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $argv ])\"";
      pythonEnv = {
        description = "start a nix-shell with the given python packages";
        argumentNames = [ "pythonVersion" ];
        body = ''
          if set -q argv[2]
            set argv $argv[2..-1]
          end
        
          for el in $argv
            set ppkgs $ppkgs "python"$pythonVersion"Packages.$el"
          end
        
          nix-shell -p $ppkgs
        '';
      };
    };
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
          sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
        };
      }
    ];
    shellAliases = {
      g = "git";
    };
  };
  programs.zoxide.enable = true;

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
