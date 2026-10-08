let
  bitwarden = "nngceckbapebfimnlniiiahkandclblb";
  darkReader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
  sponsorBlock = "mnjggcdmjocbbbhaepdhchncahnbgone";
  blackHoleTheme = "faeadnfmdfamenfhaipofoffijhlnkif";
  vimiumC = "hfjbmagddngcpeloejdejnfgbamkjaeg";
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
        {id = vimiumC;}
      ];
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--disk-cache-size=1073741824"
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,ParallelDownloading,AsyncDns,BackForwardCache,Prerender2,SpeculativeServiceWorkerWarmUp"
        "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
      ];
    };

    home.file.".config/BraveSoftware/Brave-Origin/policies/managed/policy.json".text = builtins.toJSON {
      PasswordManagerEnabled = false;
      PasswordLeakDetectionEnabled = false;
      PasswordDismissCompromisedAlertEnabled = false;
      PasswordSharingEnabled = false;
      BrowserSignin = 0;
      DnsOverHttpsMode = "off";
      SyncDisabled = true;
      EnableMediaRouter = false;
      AudioCaptureAllowed = true;
      VideoCaptureAllowed = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DefaultBrowserSettingEnabled = false;
      # 5 = Open New Tab page on clean launch; preserves session restore on crash
      RestoreOnStartup = 5;
      BackgroundModeEnabled = false;
      ShowCastIconInToolbar = false;
      HttpsOnlyMode = "force_enabled";
      BookmarkBarEnabled = false;
      EditBookmarksEnabled = false;
      ImportBookmarks = false;

      DefaultBraveFingerprintingV2Setting = 3;

      # 0 = prefetch, preconnect and prerender on any connection (speculative prefetching)
      NetworkPredictionOptions = 0;
      SearchSuggestEnabled = true;
      AlternateErrorPagesEnabled = false;
      MetricsReportingEnabled = false;
      HighEfficiencyModeEnabled = true;
      MemorySaverModeSavings = 2;

      DefaultGeolocationSetting = 2;

      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Brave Search";
      DefaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
      DefaultSearchProviderSuggestURL = "https://search.brave.com/api/suggest?q={searchTerms}";

      ExtensionSettings = {
        "${darkReader}" = {
          toolbar_pin = "force_pinned";
        };
      };
    };
  };
}
