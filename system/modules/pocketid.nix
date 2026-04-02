{ config, pkgs, ... }:
{
  services.tailscale.enable = true;

  services.pocket-id = {
    enable = true;
    settings = {
      PUBLIC_APP_URL = "https://id.luko.dev";
      TRUST_PROXY = true;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."id.luko.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:1411";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "services@luko.dev";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Tailscale Funnel exposes pocket-id via the ts.net hostname as well.
  # Requires the node to be authenticated: run `tailscale funnel status` to verify.
  systemd.services.tailscale-funnel-pocketid = {
    description = "Configure Tailscale Funnel for Pocket ID";
    after = [ "tailscaled.service" "pocket-id-frontend.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.tailscale ];
    script = ''
      tailscale funnel --bg http://127.0.0.1:1411
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
