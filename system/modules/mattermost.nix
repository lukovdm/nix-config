{ config, ... }:
{
  services.mattermost = {
    enable = true;
    siteName = "BF2 Board Mattermost";
    siteUrl = "https://mm.luko.dev";
  };

  services.nginx.virtualHosts = {
    "mm.luko.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8065";
        proxyWebsockets = true;
      };
    };
  };
}
