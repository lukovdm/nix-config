{config, pkgs, ...} :
{
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
        name = "theme-lambda";
        src = pkgs.fetchFromGitHub {
          owner = "hasanozgan";
          repo = "theme-lambda";
          rev = "1d599f05dc560d7c9fa0660fa72e2d32251f6f65";
          sha256 = "1s0pyc7nlxlynszlskmzrg57rq2nszbkzjq714hl15g1 gxp95k";
        };
      }
    ];

    shellAliases = {
      g = "git";
      ls = "exa";
      ping = "prettyping";
    };

    interactiveShellInit = ''
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';
  };
}