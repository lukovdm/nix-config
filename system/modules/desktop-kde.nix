{ pkgs, ... }:
{
  # Display manager
  services.xserver.enable = true;

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    xorg.xkill

    kdePackages.kdeconnect-kde
    kdePackages.krunner
    kdePackages.sddm-kcm
    kdePackages.ark
    kdePackages.xdg-desktop-portal-kde
  ];
}
