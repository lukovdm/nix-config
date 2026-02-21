{ config, ... }:
{
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
    tokenFile = config.age.secrets.bbg-mm-token.path;
    stateFile = "/var/lib/bgg-mm/availability.json";

    bgg = {
      username = "mageleve";
    };

    shop = {
      baseUrl = "http://www.moenen-en-mariken.nl";
    };

    ntfy = {
      topic = "bgg_mm_luko";
    };
  };
}
