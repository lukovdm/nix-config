{ config, pkgs, ... }:
{
  services.borgbackup.jobs.home = {
    paths = "/home/luko";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/luko/.ssh/id_ed25519";
    repo = "ssh://'Luko van der Maas'@nas-opdeboot:/var/services/homes/'Luko van der Maas'/Barium";
    compression = "auto,zstd";
    startAt = "daily";
    preHook = "tailscale up";
    exclude = [
      ".cache"
      "*/cache2" # firefox
      "*/Cache"
      ".config/Slack/logs"
      ".config/Code/CachedData"
      ".container-diff"
      ".npm/_cacache"
      "*/node_modules"
      "*/bower_components"
      "*/_build"
      "*/.tox"
      "*/venv"
      "*/.venv"
    ];
  };
}
