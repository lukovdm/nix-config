{ config, ... }:
{
  # Tailscale
  services.tailscale.enable = true;

  # Firewall
  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; } { from = 8000; to = 8443; } { from = 27015; to = 27036; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; } { from = 27015; to = 27036; } { from = 10999; to = 10999; } { from = 24642; to = 24642; }];
  networking.firewall.allowedTCPPorts = [ 8010 ]; # vlc chromecast
  networking.firewall.allowedUDPPorts = [ 51820 ]; # tailscale

  networking.firewall.checkReversePath = "loose";

  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "lukovdm.github.beta.tailscale.net" ];
}
