{
  programs.firefox.profiles.rebiz = {
    settings = {
      # speed
      "browser.cache.disk.enable" = true;
      "browser.places.speculativeConnect.enabled" = true;
      "browser.urlbar.speculativeConnect.enabled" = true;
      "network.dns.disablePrefetch" = false;
      "network.dns.disablePrefetchFromHTTPS" = false;
      "network.http.speculative-parallel-limit" = 10;
      "network.predictor.enable-prefetch" = true;
      "network.predictor.enabled" = true;
      "network.prefetch-next" = true;

      # usability
      "browser.download.useDownloadDir" = true;
      "browser.newtabpage.enabled" = true;
      "browser.search.suggest.enabled" = true;
      "browser.sessionstore.resume_from_crash" = true;
      "browser.startup.homepage" = "about:home";
      "browser.startup.page" = 1;
      "browser.uidensity" = 1;
      "browser.urlbar.suggest.searches" = true;
      "identity.fxaccounts.enabled" = false;
      "layout.spellcheckDefault" = 0;
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
      "sidebar.visibility" = "expand-on-hover";

      # your choice
      "media.autoplay.default" = 5;
      "permissions.default.desktop-notification" = 0;
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown_v2.formdata" = false;
      "privacy.resistFingerprinting" = true;
      "privacy.sanitize.sanitizeOnShutdown" = false;
    };
  };
}
