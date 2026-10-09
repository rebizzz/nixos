_: {
  flake.modules.nixos.brave = {
    programs.chromium = {
      enable = true;

      initialPrefs = {
        brave = {
          tabs = {
            hover_mode = 2;
          };
        };
      };

      extraOpts = {
        # Startup & Window Behavior
        RestoreOnStartup = 5; # Open New Tab page; preserves session restore on crash
        BackgroundModeEnabled = false;

        # Search Engine & Omnibox
        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderName = "Brave Search";
        DefaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
        DefaultSearchProviderSuggestURL = "https://search.brave.com/api/suggest?q={searchTerms}";
        SearchSuggestEnabled = true; # Keep speculative searchbar suggestions active
        NetworkPredictionOptions = 0; # 0 = prefetch, preconnect and prerender on any connection
        ShowFullUrlsInAddressBar = true;

        # Bookmarks & UI Cleanup
        BookmarkBarEnabled = false;
        EditBookmarksEnabled = false;
        ImportBookmarks = false;
        ShowCastIconInToolbar = false;
        EnableMediaRouter = false;

        # Password Manager & Autofill (Bitwarden used instead)
        PasswordManagerEnabled = false;
        PasswordLeakDetectionEnabled = false;
        PasswordDismissCompromisedAlertEnabled = false;
        PasswordSharingEnabled = false;
        PasswordManagerPasskeysEnabled = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        AutofillPredictionSettings = 2;

        # Brave Telemetry & Ads Killswitches
        BraveSearchResultAdsEnabled = false;
        BraveNewsDisabled = true;
        BraveWaybackMachineEnabled = false;
        BraveP3AEnabled = false;
        BraveStatsPingEnabled = false;
        BraveWebDiscoveryEnabled = false;

        # Brave Built-in Privacy Shields
        BraveDeAmpEnabled = true;
        BraveDebouncingEnabled = true;
        BraveGlobalPrivacyControlEnabled = true;
        BraveTrackingQueryParametersFilteringEnabled = true;
        BraveReduceLanguageEnabled = true;
        DefaultBraveFingerprintingV2Setting = 3;
        DefaultBraveAdblockSetting = 2;
        DefaultBraveHttpsUpgradeSetting = 2;
        DefaultBraveReferrersSetting = 2;

        # Upstream Chromium AI Killswitches
        GenAiDefaultSettings = 2;
        AIModeSettings = 1;
        BuiltInAIAPIsEnabled = false;
        AutofillGenAiSettings = 2;
        DevToolsGenAiSettings = 2;
        HelpMeWriteSettings = 2;
        HelpMeReadSettings = 2;
        CreateThemesSettings = 2;
        TabCompareSettings = 2;
        HistorySearchSettings = 2;
        FindAndFillWithGeminiSettings = 2;
        GenAIInlineImageSettings = 2;
        GenAILocalFoundationalModelSettings = 1;
        GenAIPhotoEditingSettings = 2;
        GenAISmartGroupingSettings = 2;
        GenAIVcBackgroundSettings = 2;
        GenAIWallpaperSettings = 2;
        SearchContentSharingSettings = 2;
        SmartTabSharingSettings = 1;
        ThirdPartyAiChatSettings = 1;
        ShowAiIntroScreenEnabled = false;
        ShowGeminiIntroScreenEnabled = false;

        # Privacy, Security & Network Hardening
        WebRtcIPHandling = "disable_non_proxied_udp";
        EncryptedClientHelloEnabled = true;
        PostQuantumKeyAgreementEnabled = true;
        DevicePostQuantumKeyAgreementEnabled = true;
        HttpsOnlyMode = "force_enabled";
        HttpsUpgradesEnabled = true;
        BlockThirdPartyCookies = true;
        BrowserSignin = 0;
        SyncDisabled = true;
        SpellCheckServiceEnabled = false;
        UrlKeyedAnonymizedDataCollectionEnabled = false;
        MetricsReportingEnabled = false;
        GoogleLocationServicesEnabled = 0;
        GoogleSearchSidePanelEnabled = false;
        ContextualGoogleIntegrationsEnabled = false;
        ContextualSearchEnabled = false;
        FeedbackSurveysEnabled = false;
        UserFeedbackAllowed = false;
        DomainReliabilityAllowed = false;
        CloudPrintProxyEnabled = false;
        AlternateErrorPagesEnabled = false;
        DnsOverHttpsMode = "off";
        DefaultBrowserSettingEnabled = false;
        HardwareAccelerationModeEnabled = true;

        # Performance & Memory Saver
        HighEfficiencyModeEnabled = true;
        MemorySaverModeSavings = 1; # 0 = Moderate, 1 = Balanced, 2 = Maximum

        ExtensionSettings = {
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" = {
            toolbar_pin = "force_pinned";
          };
        };
      };
    };
  };
}
