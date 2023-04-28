{ config, ... }:
{
  services.jellyfin =
    {
      enable = true;
      openFirewall = true;
      user = "luko";
      group = "users"
        };
    }
