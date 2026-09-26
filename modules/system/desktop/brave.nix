let
  darkReader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
in {
  flake.modules.nixos.brave = _: {
    programs.chromium = {
      enable = true;
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
      defaultSearchProviderSuggestURL = "https://search.brave.com/api/suggest?q={searchTerms}";
      extraOpts = {
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
