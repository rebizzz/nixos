{inputs, ...}: {
  flake.modules.nixos.nixarr = {config, ...}: {
    imports = [inputs.nixarr.nixosModules.default];

    nixarr = {
      enable = true;

      mediaDir = "/mnt/data/media";
      stateDir = "/mnt/data/storage/.state/nixarr";
      mediaUsers = [config.myConfig.user.name];

      jellyfin = {
        enable = true;
        openFirewall = true;
      };

      sonarr = {
        enable = true;
        openFirewall = true;
        settings-sync.transmission.enable = true;
      };

      radarr = {
        enable = true;
        openFirewall = true;
        settings-sync.transmission.enable = true;
      };

      prowlarr = {
        enable = true;
        openFirewall = true;
        settings-sync.enable-nixarr-apps = true;
      };

      transmission = {
        enable = true;
        openFirewall = true;
      };

      bazarr = {
        enable = true;
        openFirewall = true;
        settings-sync = {
          sonarr.enable = true;
          radarr.enable = true;
        };
      };

      recyclarr = {
        enable = true;
        configuration = {
          sonarr.series = {
            base_url = "http://localhost:${toString config.nixarr.sonarr.port}";
            api_key = "!env_var SONARR_API_KEY";
            quality_definition.type = "series";
          };
          radarr.movies = {
            base_url = "http://localhost:${toString config.nixarr.radarr.port}";
            api_key = "!env_var RADARR_API_KEY";
            quality_definition.type = "movie";
          };
        };
      };
    };

    services = {
      sonarr.settings.auth.required = "DisabledForLocalAddresses";
      radarr.settings.auth.required = "DisabledForLocalAddresses";
      prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    };
  };
}
