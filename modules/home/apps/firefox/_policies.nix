{
  programs.firefox.policies = {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DisableFeedbackCommands = true;
    DisableRemoteImprovements = true;
    DontCheckDefaultBrowser = true;
    SkipTermsOfUse = true;
    DNSOverHTTPS.Enabled = false;
    FirefoxHome = {
      SponsoredStories = false;
      SponsoredTopSites = false;
      Stories = false;
    };
    GenerativeAI.Enabled = false;
    NoDefaultBookmarks = true;
    HttpsOnlyMode = "force_enabled";
    PasswordManagerEnabled = false;
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    DefaultGeolocationSetting = 2;
    SearchEngines = {
      Default = "DuckDuckGo";
      Remove = ["Amazon.com" "eBay" "Perplexity"];
    };
  };
}
