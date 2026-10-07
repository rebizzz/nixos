# credits: https://github.com/arkenfox/user.js https://github.com/yokoffing/Betterfox
{
  flake.modules.homeManager.firefox = {...}: {
    programs.firefox = {
      enable = true;
      policies = {
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
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
          };
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
          };
          "vimium-c@gdh1995.cn" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
      profiles.default = {
        id = 0;
        isDefault = true;
        settings = {
          # ---- Betterfox Peskyfox.js / MOZILLA UI ----
          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.preferences.moreFromMozilla" = false;
          "browser.profiles.enabled" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage_override.mstone" = "ignore";
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;

          # ---- Betterfox Peskyfox.js / NEW TAB PAGE ----
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # ---- arkenfox user.js v144 / GEOLOCATION ----
          "geo.provider.ms-windows-location" = false;
          "geo.provider.use_corelocation" = false;
          "geo.provider.use_geoclue" = false;

          # ---- Betterfox user.js v154 / SECUREFOX ----
          "app.normandy.api_url" = "";
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "breakpad.reportURL" = "";
          "browser.contentblocking.category" = "strict";
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.formfill.enable" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.search.update" = false;
          "browser.sessionstore.interval" = 60000;
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.uitour.enabled" = false;
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.trimHttps" = true;
          "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
          "browser.xul.error_pages.expert_bad_cert" = true;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.usage.uploadEnabled" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_error_page_user_suggestions" = true;
          "editor.truncate_user_pastes" = false;
          "extensions.enabledScopes" = 5;
          "extensions.getAddons.cache.enabled" = false;
          "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
          "media.memory_cache_max_size" = 65536;
          "network.IDN_show_punycode" = true;
          "network.auth.subresource-http-auth-allow" = 1;
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          "nimbus.rollouts.enabled" = false;
          "pdfjs.enableScripting" = false;
          "permissions.default.geo" = 2;
          "permissions.manager.defaultsUrl" = "";
          "privacy.antitracking.isolateContentScriptResources" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.history.custom" = true;
          "security.OCSP.enabled" = 0;
          "security.csp.reporting.enabled" = false;
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "security.tls.enable_0rtt_data" = false;
          "signon.formlessCapture.enabled" = false;
          "signon.privateBrowsingCapture.enabled" = false;
          "toolkit.coverage.endpoint.base" = "";
          "toolkit.coverage.opt-out" = true;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # ---- arkenfox user.js v144 / QUIETER FOX ----
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "captivedetect.canonicalURL" = "";
          "network.captive-portal-service.enabled" = false;
          "network.connectivity-service.enabled" = false;

          # ---- arkenfox user.js v144 / DNS / DOH / PROXY ----
          "network.file.disable_unc_paths" = true;
          "network.gio.supported-protocols" = "";
          "network.proxy.socks_remote_dns" = true;

          # ---- arkenfox user.js v144 / LOCATION BAR / SEARCH / SUGGESTIONS ----
          "browser.search.separatePrivateDefault" = true;
          "browser.urlbar.addons.featureGate" = false;
          "browser.urlbar.amp.featureGate" = false;
          "browser.urlbar.importantDates.featureGate" = false;
          "browser.urlbar.market.featureGate" = false;
          "browser.urlbar.mdn.featureGate" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.weather.featureGate" = false;
          "browser.urlbar.wikipedia.featureGate" = false;
          "browser.urlbar.yelp.featureGate" = false;
          "browser.urlbar.yelpRealtime.featureGate" = false;

          # ---- Betterfox Peskyfox.js / URL BAR ----
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.trending.featureGate" = false;

          # ---- arkenfox user.js v144 / PASSWORDS / PASSKEYS ----
          "security.webauthn.always_allow_direct_attestation" = false;
          "signon.autofillForms" = false;

          # ---- arkenfox user.js v144 / DISK AVOIDANCE ----
          "browser.sessionstore.privacy_level" = 2;
          "browser.shell.shortcutFavicons" = false;
          "toolkit.winRegisterApplicationRestart" = false;

          # ---- arkenfox user.js v144 / HTTPS / TLS / CERTS ----
          "dom.security.https_only_mode_send_http_background_request" = false;
          "security.cert_pinning.enforcement_level" = 2;
          "security.pki.crlite_mode" = 2;
          "security.remote_settings.crlite_filters.enabled" = true;
          "security.ssl.require_safe_negotiation" = true;

          # ---- arkenfox user.js v144 / CONTAINERS ----
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          # ---- arkenfox user.js v144 / WEBRTC / MEDIA ----
          "media.peerconnection.ice.default_address_only" = true;
          "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

          # ---- arkenfox user.js v144 / DOM ----
          "dom.disable_window_move_resize" = true;

          # ---- arkenfox user.js v144 / MISCELLANEOUS ----
          "browser.contentanalysis.default_result" = 0;
          "browser.contentanalysis.enabled" = false;
          "browser.download.alwaysOpenPanel" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.helperApps.deleteTempFileOnExit" = true;
          "browser.tabs.searchclipboardfor.middleclick" = false;
          "devtools.debugger.remote-enabled" = false;
          "extensions.postDownloadThirdPartyPrompt" = false;
          "pdfjs.disabled" = false;

          # ---- Betterfox Peskyfox.js / DOWNLOADS ----
          "browser.download.manager.addToRecentDocs" = false;

          # ---- arkenfox user.js v144 / TRACKING PROTECTION (ETP) ----
          "privacy.trackingprotection.allow_list.baseline.enabled" = true;
          "privacy.trackingprotection.allow_list.convenience.enabled" = true;

          # ---- arkenfox user.js v144 / SHUTDOWN & SANITIZING ----
          "privacy.clearHistory.browsingHistoryAndDownloads" = false;
          "privacy.clearHistory.cache" = true;
          "privacy.clearHistory.cookiesAndStorage" = false;
          "privacy.clearHistory.formdata" = true;
          "privacy.clearHistory.historyFormDataAndDownloads" = false;
          "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
          "privacy.clearOnShutdown_v2.downloads" = false;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
          "privacy.clearSiteData.browsingHistoryAndDownloads" = false;
          "privacy.clearSiteData.cache" = true;
          "privacy.clearSiteData.cookiesAndStorage" = false;
          "privacy.clearSiteData.formdata" = true;
          "privacy.clearSiteData.historyFormDataAndDownloads" = false;
          "privacy.sanitize.timeSpan" = 0;

          # ---- arkenfox user.js v144 / RESIST FINGERPRINTING (RFP, optional) ----
          "browser.link.open_newwindow" = 3;
          "browser.link.open_newwindow.restriction" = 0;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "privacy.spoof_english" = 1;
          "privacy.window.maxInnerHeight" = 900;
          "privacy.window.maxInnerWidth" = 1600;
          "widget.non-native-theme.use-theme-accent" = false;

          # ---- arkenfox user.js v144 / DON'T TOUCH ----
          "extensions.blocklist.enabled" = true;
          "extensions.quarantinedDomains.enabled" = true;
          "extensions.webcompat-reporter.enabled" = false;
          "extensions.webcompat.enable_shims" = true;
          "network.http.referer.spoofSource" = false;
          "privacy.firstparty.isolate" = false;
          "security.dialog_enable_delay" = 1000;
          "security.tls.version.enable-deprecated" = false;

          # ---- arkenfox user.js v144 / NON-PROJECT RELATED ----
          "browser.urlbar.showSearchTerms.enabled" = false;

          # ---- Betterfox user.js v154 / FASTFOX ----
          "content.notify.interval" = 100000;
          "gfx.canvas.accelerated.cache-size" = 512;
          "gfx.content.skia-font-cache-size" = 20;
          "image.mem.decode_bytes_at_a_time" = 32768;
          "media.cache_readahead_limit" = 3600;
          "media.cache_resume_threshold" = 1800;
          "network.buffer.cache.count" = 48;
          "network.buffer.cache.size" = 65535;
          "network.dnsCacheExpiration" = 3600;
          "network.http.max-connections" = 1800;
          "network.http.max-persistent-connections-per-server" = 10;
          "network.http.max-urgent-start-excessive-connections-per-host" = 5;
          "network.http.request.max-start-delay" = 5;

          # ---- Betterfox Peskyfox.js / THEME ADJUSTMENTS ----
          "browser.compactmode.show" = true;
          "browser.privateWindowSeparation.enabled" = false;
          "layout.css.prefers-color-scheme.content-override" = 2;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # ---- Betterfox Peskyfox.js / AI ----
          "browser.ai.control.default" = "blocked";
          "browser.ml.chat.enabled" = false;
          "browser.ml.chat.menu" = false;
          "browser.ml.enable" = false;
          "browser.ml.linkPreview.enabled" = false;
          "browser.tabs.groups.smart.enabled" = false;

          # ---- Betterfox Peskyfox.js / FULLSCREEN NOTICE ----
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";

          # ---- Betterfox user.js v154 / PESKYFOX ----
          "full-screen-api.warning.timeout" = 0;

          # ---- Betterfox Peskyfox.js / PDF ----
          "browser.download.open_pdf_attachments_inline" = true;

          # ---- Betterfox Peskyfox.js / TAB BEHAVIOR ----
          "browser.bookmarks.openInTabClosesMenu" = false;
          "findbar.highlightAll" = true;

          # ---- Betterfox Smoothfox.js / SCROLLING (instant) ----
          "apz.overscroll.enabled" = true;
          "general.smoothScroll" = true;
          "general.smoothScroll.msdPhysics.enabled" = false;
          "mousewheel.default.delta_multiplier_y" = 275;

          # ---- MY OVERRIDES ----
          # SPEED
          "browser.cache.disk.enable" = true;
          "browser.places.speculativeConnect.enabled" = true;
          "browser.urlbar.speculativeConnect.enabled" = true;
          "network.dns.disablePrefetch" = false;
          "network.dns.disablePrefetchFromHTTPS" = false;
          "network.http.speculative-parallel-limit" = 10;
          "network.predictor.enable-prefetch" = true;
          "network.predictor.enabled" = true;
          "network.prefetch-next" = true;
          # USABILITY
          "browser.download.useDownloadDir" = true;
          "browser.newtabpage.enabled" = true;
          "browser.search.suggest.enabled" = true;
          "browser.startup.homepage" = "about:home";
          "browser.startup.page" = 3;
          "browser.urlbar.suggest.searches" = true;
          # MY CHOICE
          "media.autoplay.default" = 5;
          "permissions.default.desktop-notification" = 0;
          "privacy.clearOnShutdown_v2.cache" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "privacy.clearOnShutdown_v2.formdata" = false;
          "privacy.resistFingerprinting" = true;
          "privacy.sanitize.sanitizeOnShutdown" = false;
        };
      };
    };
  };
}
