{ config, lib, pkgs, ... }:
{
  services.borgbackup.jobs.home = {
    paths = "/home/luko";
    encryption.mode = "none";
    environment = {
      # Krypton's Tailscale IP, so backups work from any network.
      # HostKeyAlias reuses the existing known_hosts entry for "krypton".
      BORG_RSH = "ssh -i /home/luko/.ssh/id_rsa -o HostKeyAlias=krypton";
      BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
    };
    repo = "borg@100.112.176.84:/bigmedia/backup/barium";
    compression = "auto,zstd";
    extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
    startAt = "daily";
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
    user = "luko";
    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = -1; # Keep at least one archive for each month
    };
  };

  systemd.timers."borgbackup-job-home" = {
    timerConfig.Persistent = lib.mkForce true;
  };
}
