{ config, lib, ... }:
let
  cfg = config.services;
in
{
  age.secrets.homepage-env = {
    file = ../../secrets/homepage-env.age;
    owner = "homepage-dashboard";
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;
    openFirewall = true;
    environmentFile = config.age.secrets.homepage-env.path;

    settings = {
      title = "Krypton";
      headerStyle = "clean";
      layout = {
        Media = { style = "row"; columns = 3; };
        "Downloads & Indexing" = { style = "row"; columns = 3; };
        Photos = { style = "row"; columns = 1; };
        Comms = { style = "row"; columns = 1; };
      };
    };

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ];

    # Services: each group only appears if the relevant module is enabled.
    services = lib.filter (g: g != null) [

      (lib.mkIf cfg.jellyfin.enable {
        Media = [
          {
            Jellyfin = {
              href = "http://krypton:8096";
              description = "Media server";
              icon = "jellyfin.svg";
              widget = {
                type = "jellyfin";
                url = "http://localhost:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
                enableBlocks = true;
              };
            };
          }
        ];
      })

      (lib.mkIf cfg.radarr.enable {
        Media = [
          {
            Radarr = {
              href = "http://krypton:7878";
              description = "Movie management";
              icon = "radarr.svg";
              widget = {
                type = "radarr";
                url = "http://localhost:7878";
                key = "{{HOMEPAGE_VAR_RADARR_KEY}}";
              };
            };
          }
        ];
      })

      (lib.mkIf cfg.sonarr.enable {
        Media = [
          {
            Sonarr = {
              href = "http://krypton:8989";
              description = "TV show management";
              icon = "sonarr.svg";
              widget = {
                type = "sonarr";
                url = "http://localhost:8989";
                key = "{{HOMEPAGE_VAR_SONARR_KEY}}";
              };
            };
          }
        ];
      })

      (lib.mkIf cfg.transmission.enable {
        "Downloads & Indexing" = [
          {
            Transmission = {
              href = "http://krypton:9091";
              description = "Torrent client";
              icon = "transmission.svg";
              widget = {
                type = "transmission";
                url = "http://localhost:9091";
                username = "{{HOMEPAGE_VAR_TRANSMISSION_USER}}";
                password = "{{HOMEPAGE_VAR_TRANSMISSION_PASS}}";
              };
            };
          }
        ];
      })

      (lib.mkIf cfg.prowlarr.enable {
        "Downloads & Indexing" = [
          {
            Prowlarr = {
              href = "http://krypton:9696";
              description = "Indexer manager";
              icon = "prowlarr.svg";
              widget = {
                type = "prowlarr";
                url = "http://localhost:9696";
                key = "{{HOMEPAGE_VAR_PROWLARR_KEY}}";
              };
            };
          }
        ];
      })

      (lib.mkIf cfg.bazarr.enable {
        "Downloads & Indexing" = [
          {
            Bazarr = {
              href = "http://krypton:6767";
              description = "Subtitle manager";
              icon = "bazarr.svg";
              widget = {
                type = "bazarr";
                url = "http://localhost:6767";
                key = "{{HOMEPAGE_VAR_BAZARR_KEY}}";
              };
            };
          }
        ];
      })

      (lib.mkIf cfg.photoprism.enable {
        Photos = [
          {
            Photoprism = {
              href = "http://krypton:2342";
              description = "Photo library";
              icon = "photoprism.svg";
              widget = {
                type = "photoprism";
                url = "http://localhost:2342";
                username = "{{HOMEPAGE_VAR_PHOTOPRISM_USER}}";
                password = "{{HOMEPAGE_VAR_PHOTOPRISM_PASS}}";
              };
            };
          }
        ];
      })

      (lib.mkIf cfg.mattermost.enable {
        Comms = [
          {
            Mattermost = {
              href = "https://mm.luko.dev";
              description = "Team chat";
              icon = "mattermost.svg";
            };
          }
        ];
      })

    ];
  };
}
