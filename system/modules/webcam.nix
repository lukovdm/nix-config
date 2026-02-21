{ config, ... }: {
  age.secrets.restreamer-credentials = {
    file = ../../secrets/restreamer-credentials.age;
    owner = "root";
  };

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
          "RS_MODE" = "USBCAM";
          "RS_USBCAM_VIDEODEVICE" = "/dev/video0";
        };
        environmentFiles = [
          config.age.secrets.restreamer-credentials.path
        ];
        extraOptions = [
          "--device=/dev/video0:/dev/video0"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
