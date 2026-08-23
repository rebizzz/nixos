let
  bitwarden = "nngceckbapebfimnlniiiahkandclblb";
  darkReader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
  sponsorBlock = "mnjggcdmjocbbbhaepdhchncahnbgone";
  blackHoleTheme = "faeadnfmdfamenfhaipofoffijhlnkif";
in {
  flake.modules.homeManager.brave = {pkgs, ...}: {
    programs.brave = {
      enable = true;
      package = pkgs.brave-origin;
      extensions = [
        {id = bitwarden;}
        {id = darkReader;}
        {id = sponsorBlock;}
        {id = blackHoleTheme;}
      ];
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization"
        "--disable-features=UseChromeOSDirectVideoDecoder"
      ];
    };
  };

  flake.modules.nixos.brave-policy = {config, ...}: {
    sops.templates."brave-dns-policy.json" = {
      content = builtins.toJSON {
        DnsOverHttpsTemplates = "https://dns.nextdns.io/${config.sops.placeholder.nextdns_profile_id}/Brave";
      };
      mode = "0444";
    };

    systemd.tmpfiles.rules = [
      "L+ /etc/brave/policies/managed/nextdns.json - - - - ${config.sops.templates."brave-dns-policy.json".path}"
    ];

    programs.chromium = {
      enable = true;
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
      defaultSearchProviderSuggestURL = "https://search.brave.com/api/suggest?q={searchTerms}";
      extraOpts = {
        PasswordManagerEnabled = false;
        BrowserSignin = 0;
        DnsOverHttpsMode = "secure";
        SyncDisabled = true;
        EnableMediaRouter = false;
        AudioCaptureAllowed = true;
        VideoCaptureAllowed = true;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DefaultBrowserSettingEnabled = false;
        RestoreOnStartup = 5;
        BackgroundModeEnabled = false;
        ShowCastIconInToolbar = false;
        HttpsOnlyMode = "force_enabled";
        BookmarkBarEnabled = false;

        DefaultBraveFingerprintingV2Setting = 3;

        NetworkPredictionOptions = 2;
        SearchSuggestEnabled = true;
        AlternateErrorPagesEnabled = false;
        MetricsReportingEnabled = false;
        HighEfficiencyModeEnabled = true;
        MemorySaverModeSavings = 1;

        DefaultNotificationsSetting = 2;
        DefaultGeolocationSetting = 2;

        ExtensionSettings = {
          "${darkReader}" = {
            toolbar_pin = "force_pinned";
          };
        };
      };
    };
  };
}
