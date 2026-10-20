{ pkgs, ... }:
{
  # Stylix theming
  stylix = {
    enable = true;
    image = ../../wallpaper.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    opacity = {
      terminal = 0.9;
      popups = 0.9;
    };
    fonts = {
      monospace = { package = pkgs.nerd-fonts.fira-code; name = "FiraCode Nerd Font"; };
      sansSerif = { package = pkgs.dejavu_fonts; name = "DejaVu Sans"; };
      serif = { package = pkgs.dejavu_fonts; name = "DejaVu Serif"; };
      emoji = { package = pkgs.noto-fonts-color-emoji; name = "Noto Color Emoji"; };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}
