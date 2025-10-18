{ config, pkgs, ... }:
{
  users.groups.media = {
    members = [ "radarr" "sonarr" "transmission" "jellyfin" ];
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
    package = pkgs.sonarr;
  };
  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.bazarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  systemd.services.prowlarr.environment = {
    DOTNET_CLI_HOME = "/tmp/";
  };
  services.transmission = {
    enable = true;
    group = "media";
    openFirewall = true;
    openRPCPort = true;
    settings = {
      blocklist-enabled = true;
      blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
      download-dir = "/bigmedia/Torrents";
      incomplete-dir = "/bigmedia/Incomplete_Torrents/";
      encryption = 1;
      message-level = 1;
      peer-port = 50778;
      peer-port-random-high = 65535;
      peer-port-random-low = 49152;
      peer-port-random-on-start = true;
      rpc-enable = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      rpc-authentication-required = true;
      rpc-username = "xenon";
      rpc-password = "xenon";
      umask = 18;
      utp-enabled = true;
    };
  };
}
