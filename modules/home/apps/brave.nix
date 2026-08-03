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
        "--enable-features=VaapiVideoDecoder"
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime"
      ];
    };
  };

  flake.modules.nixos.brave-policy = _: {
    programs.chromium = {
      enable = true;
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
      defaultSearchProviderSuggestURL = "https://search.brave.com/api/suggest?q={searchTerms}";
      extraOpts = {
        PasswordManagerEnabled = false;
        BrowserSignin = 0;
        DnsOverHttpsMode = "secure";
        DnsOverHttpsTemplates = "https://dns.nextdns.io/d4e7df/Brave";
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

        SpellcheckServiceEnabled = false;

        ExtensionSettings = {
          "${darkReader}" = {
            toolbar_pin = "force_pinned";
          };
        };
      };
    };
  };
}
