let
  darkReader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
in {
  flake.modules.nixos.brave = {config, ...}: {

    programs.chromium = {
      enable = true;
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
      defaultSearchProviderSuggestURL = "https://search.brave.com/api/suggest?q={searchTerms}";
      extraOpts = {
        # brave-origin compiles all of these out. kept in case we ever go back
        # to upstream brave.
        #   BraveRewardsDisabled = true;
        #   BraveWalletDisabled = true;
        #   TorDisabled = true;
        #   BraveAIChatEnabled = false;
        #   BraveVPNDisabled = true;
        #   BraveNewsDisabled = true;
        #   BraveTalkDisabled = true;
        #   BraveSpeedreaderEnabled = false;
        #   BraveWebDiscoveryEnabled = 0;
        #   BraveP3AEnabled = false;
        #   BraveStatsPingEnabled = false;

        # Privacy & Security
        PasswordManagerEnabled = false;
        BrowserSignin = 0;
        DnsOverHttpsMode = "off";
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

        NetworkPredictionOptions = 0;
        SearchSuggestEnabled = true;
        AlternateErrorPagesEnabled = false;
        MetricsReportingEnabled = false;
        HighEfficiencyModeEnabled = true;
        MemorySaverModeSavings = 2;

        # DefaultNotificationsSetting = 2;
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
