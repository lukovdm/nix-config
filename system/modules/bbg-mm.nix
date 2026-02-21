{ config, ... }:
{
  age.secrets.bbg-mm-token = {
    file = ../../secrets/bbg-mm-token.age;
    owner = "bgg-mm";
  };

  services.bgg-mm = {
    enable = true;
    schedule = "0 8 * * *";
    tokenFile = config.age.secrets.bbg-mm-token.path;

    bgg = {
      username = "mageleve";
    };

    ntfy = {
      topic = "bgg_mm_luko";
    };
  };
}
