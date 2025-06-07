{ config, ... }: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      piwigo = {
        autoStart = true;
        image = "lscr.io/linuxserver/piwigo:latest";
        ports = [ "8888:80" ];
        volumes = [
          "/media/piwigo/config:/config"
          "/media/piwigo/gallery:/gallery"
        ];
        environment = {
          "PUID" = "1000";
          "PGID" = "1000";
          "TZ" = "Europe/Amsterdam";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8888 ];
}
