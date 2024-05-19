{ config, ... }: {
  virtualisation.oci-containers.containers = {
    restreamer = {
      autostart = true;
      image = "datarhei/restreamer:latest";
      portMap = {
        "8080:8080/tcp" = 8080;
      };
      volumes = [
        "/var/lib/restreamer/db:/restreamer/db"
      ];
      environment = {
        "RS_USERNAME" = "admin";
        "RS_PASSWORD" = "admin";
        "RS_MODE" = "USBCAM";
      };
      extraOptions = [
        "--device=/dev/video0:/dev/video"
      ];
    };
  };
}
