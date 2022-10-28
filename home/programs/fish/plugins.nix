{ pkgs }:

let
  bobthefish = {
    name = "theme-bobthefish";
    src = pkgs.fish-bobthefish-theme;
  };
in
{
  theme = bobthefish;
  prompt = builtins.readFile "${bobthefish.src}/fish_prompt.fish";
}
