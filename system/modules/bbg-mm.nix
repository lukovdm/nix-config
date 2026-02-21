{ config, ... }:
{
  age.secrets.bbg-mm-config = {
    file = ../../secrets/bbg-mm-config.age;
    owner = "bggmm";
  };

  age.secrets.bbg-mm-token = {
    file = ../../secrets/bbg-mm-token.age;
    owner = "bggmm";
  };

  users.users.bggmm = {
    isSystemUser = true;
    group = "bggmm";
    home = "/var/lib/bgg-mm";
    createHome = true;
  };
  users.groups.bggmm = { };

  services.bgg-mm = {
    enable = true;
    user = "bggmm";
    schedule = "0 8 * * *";
    configFile = config.age.secrets.bbg-mm-config.path;
    tokenFile = config.age.secrets.bbg-mm-token.path;
  };
}
