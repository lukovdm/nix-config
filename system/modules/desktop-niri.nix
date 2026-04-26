{ pkgs, ... }:
{
  programs.niri.enable = true;

  # Login manager — SDDM works with niri too, easy to switch back to KDE
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # XDG portals for file picker, screencasting
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # Keyring for secrets (1Password, browser passwords, etc.)
  # gnome-keyring implements the same freedesktop Secret Service D-Bus API as KWallet,
  # so apps like Firefox/1Password work transparently with either.
  # Auto-unlocks via PAM (same login password).
  services.gnome.gnome-keyring.enable = true;

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
      emoji = { package = pkgs.noto-fonts-emoji; name = "Noto Color Emoji"; };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}
