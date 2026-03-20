{ config, pkgs, ... }:
{
  services.borgbackup.repos.barium = {
    path = "/media/backup/barium";
    authorizedKeysUsers = [ "luko" ];
  };
}
