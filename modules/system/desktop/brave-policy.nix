let
  darkReader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
in {
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
        # Brave Feature / Bloat Disabling
        BraveRewardsDisabled = true;
        BraveWalletDisabled = true;
        TorDisabled = true;
        BraveAIChatEnabled = false;
        BraveVPNDisabled = true;
        BraveNewsDisabled = true;
        BraveTalkDisabled = true;
        BraveSpeedreaderEnabled = false;
        BraveWebDiscoveryEnabled = 0;
        BraveP3AEnabled = false;
        BraveStatsPingEnabled = 0;

        # Privacy & Security
        SendDoNotTrackEnabled = true;
        SpeechRecognitionEnabled = false;
        PromotionalTabsEnabled = false;
        PasswordManagerEnabled = false;
        BrowserSignin = 0;
        DnsOverHttpsMode = "secure";
        SyncDisabled = true;
        EnableMediaRouter = false;
        MediaRouterEnabled = false;
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
