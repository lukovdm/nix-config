{ config, ... }: {
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      restreamer = {
        autoStart = true;
        image = "datarhei/restreamer:latest";
        ports = [ "8080:8080" ];
        volumes = [
          "/var/lib/restreamer/db:/restreamer/db"
        ];
        environment = {
          "RS_USERNAME" = "admin";
          "RS_PASSWORD" = "admin";
          "RS_MODE" = "USBCAM";
          "RS_USBCAM_VIDEODEVICE" = "/dev/video0";
        };
        extraOptions = [
          "--device=/dev/video0:/dev/video0"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
