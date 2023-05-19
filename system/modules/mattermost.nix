{ config, ... }:
{
  services.mattermost = {
    enable = true;
    siteName = "BF2 Board Mattermost";
    siteUrl = "https://mm.luko.dev";
    forward80To443 = true;
  };

  services.nginx.virtualHosts."mm.luko.dev" = {
    enableACME = true;
    foreceSSL = true;
    location."/" = {
      proxyPass = "http://127.0.0.1:8065";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."home.luko.dev" = {
    enableACME = true;
    forceSSL = true;
    location."/" = {
      proxyPass = "http://192.168.1.127:8123";
      proxyWebsockets = true;
    };
  };
}
