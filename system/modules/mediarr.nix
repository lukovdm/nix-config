{ config, ... }:
{
  users.groups.media = {
    members = [ "radarr" "radarr" "sonarr" "transmission" "jellyfin" ];
    gid = 3000;
  };
  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
  };
}
