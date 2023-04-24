{ config, ... }:
{
  users.groups.media = {
    members = [ "radarr" "radarr" "sonarr" "transmission" "jellyfin" ];
    gid = 3000;
  };
  services.radarr = {
    enable = true;
    group = "media";
  };
  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.jellyfin = {
    enable = true;
    group = "media";
  };
  services.prowlarr = {
    enable = true;
  };
}
