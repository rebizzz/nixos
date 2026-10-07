{
  programs.firefox.profiles.rebiz = {
    settings = {
      # speed (chrome-standard balanced prefetching)
      "browser.cache.disk.enable" = true;
      "browser.places.speculativeConnect.enabled" = true;
      "browser.urlbar.speculativeConnect.enabled" = true;
      "dom.prefetch_dns_for_anchor_http_document" = true;
      "dom.prefetch_dns_for_anchor_https_document" = true;
      "dom.speculation_rules.enabled" = true;
      "network.dns.disablePrefetch" = false;
      "network.dns.disablePrefetchFromHTTPS" = false;
      "network.http.speculative-parallel-limit" = 10;
      "network.predictor.enable-hover-on-ssl" = true;
      "network.predictor.enable-prefetch" = true;
      "network.predictor.enabled" = true;
      "network.predictor.preconnect-min-confidence" = 60;
      "network.predictor.prefetch-min-confidence" = 80;
      "network.predictor.preresolve-min-confidence" = 40;
      "network.prefetch-next" = true;
      "network.trr.mode" = 5;

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
      "media.eme.enabled" = true;
      "media.gmp-provider.enabled" = true;
      "media.gmp-widevinecdm.enabled" = true;
      "media.gmp-widevinecdm.visible" = true;

      # dark mode & system theme
      "extensions.activeThemeID" = "{22b0eca1-8c02-4c0d-a5d7-6604ddd9836e}";
      "layout.css.prefers-color-scheme.content-override" = 0;
      "browser.theme.content-theme" = 0;
      "browser.theme.toolbar-theme" = 0;
      "widget.use-xdg-desktop-portal.settings" = 1;

      "permissions.default.desktop-notification" = 0;
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown_v2.formdata" = false;
      "privacy.resistFingerprinting" = true;
      "privacy.sanitize.sanitizeOnShutdown" = false;
    };
  };
}
