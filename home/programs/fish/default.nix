{config, pkgs, ...} :
let
  fzfConfig = ''
    set -x FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
    set -x SKIM_DEFAULT_COMMAND "rg --files || fd || find ."
  '';

  themeConfig = ''
    set -g theme_display_date yes
    set -g theme_display_git_master_branch yes
    set -g theme_nerd_fonts yes
    set -g theme_newline_cursor yes
    set -g theme_color_scheme base64
    set -g theme_display_virtualenv yes
  '';

  custom = pkgs.callPackage ./plugins.nix {};

  fishConfig = ''
    function fish_greeting
      set_color $fish_color_autosuggestion
      echo "I'm completely operational, and all my circuits are functioning perfectly."
      set_color normal
    end
  '' + themeConfig;
in
{
  programs.fish = {
    enable = true;

    functions = {
      __fish_command_not_found_handler = {
        body = "/nix/store/yg6vligw4m5mw13pywd3yrvly3ldblnx-command-not-found/bin/command-not-found $argv[1]";
        onEvent = "fish_command_not_found";
      };

      fish_prompt = custom.prompt;

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
      custom.theme
    ];

    shellAliases = {
      g = "git";
      ls = "exa";
      ping = "prettyping";
      nd = "nix develop --command fish";
    };

    interactiveShellInit = ''
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';

    shellInit = fishConfig;
  };
}