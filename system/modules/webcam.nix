{ config, ... }: {
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      restreamer = {
        autoStart = true;
        image = "datarhei/restreamer:latest";
        ports = [ "8080:9000" ];
        volumes = [
          "/var/lib/restreamer/db:/restreamer/db"
        ];
        environment = {
          "RS_USERNAME" = "admin";
          "RS_PASSWORD" = "admin";
          "RS_MODE" = "USBCAM";
        };
        extraOptions = [
          "--device /dev/video0:/dev/video"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 9000 ];
}
