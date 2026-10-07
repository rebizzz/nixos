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

      # privacy & tracking protection
      "browser.send_pings" = false;
      "dom.private-attribution.submission.enabled" = false;
      "extensions.pocket.enabled" = false;
      "privacy.globalprivacycontrol.functionality.enabled" = true;
      "privacy.query_stripping.enabled" = true;
      "privacy.query_stripping.enabled.pbmode" = true;
      "privacy.query_stripping.strip_list" = "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid";
      "privacy.usercontext.about_newtab_segregation.enabled" = true;

      # device sensors
      "device.sensors.enabled" = false;
      "device.sensors.ambientLight.enabled" = false;
      "device.sensors.motion.enabled" = false;
      "device.sensors.orientation.enabled" = false;
      "device.sensors.proximity.enabled" = false;

      # safe browsing (disable google lookups & checks - modern alternatives to deprecated master switch)
      "browser.safebrowsing.malware.enabled" = false;
      "browser.safebrowsing.phishing.enabled" = false;
      "browser.safebrowsing.downloads.enabled" = false;
      "browser.safebrowsing.downloads.remote.enabled" = false;
      "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
      "browser.safebrowsing.downloads.remote.block_uncommon" = false;
      "browser.safebrowsing.downloads.remote.url" = "";
      "browser.safebrowsing.provider.google4.dataSharing.enabled" = false;
    };
  };
}
