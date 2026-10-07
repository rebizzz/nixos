# credits: https://github.com/arkenfox/user.js
{
  programs.firefox.profiles.rebiz.settings = {
    # network & speed
    "network.file.disable_unc_paths" = true;
    "network.gio.supported-protocols" = "";
    "network.proxy.socks_remote_dns" = true;

    # privacy & tracking
    "browser.link.open_newwindow" = 3;
    "browser.link.open_newwindow.restriction" = 0;
    "browser.search.separatePrivateDefault" = true;
    "browser.sessionstore.privacy_level" = 2;
    "browser.shell.shortcutFavicons" = false;
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
    "geo.provider.ms-windows-location" = false;
    "geo.provider.use_corelocation" = false;
    "geo.provider.use_geoclue" = false;
    "media.peerconnection.ice.default_address_only" = true;
    "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
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
    "privacy.resistFingerprinting.block_mozAddonManager" = true;
    "privacy.sanitize.timeSpan" = 0;
    "privacy.spoof_english" = 1;
    "privacy.trackingprotection.allow_list.baseline.enabled" = true;
    "privacy.trackingprotection.allow_list.convenience.enabled" = true;
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;
    "privacy.window.maxInnerHeight" = 900;
    "privacy.window.maxInnerWidth" = 1600;
    "toolkit.winRegisterApplicationRestart" = false;
    "widget.non-native-theme.use-theme-accent" = false;

    # security
    "dom.disable_window_move_resize" = true;
    "dom.security.https_only_mode_send_http_background_request" = false;
    "security.cert_pinning.enforcement_level" = 2;
    "security.pki.crlite_mode" = 2;
    "security.remote_settings.crlite_filters.enabled" = true;
    "security.ssl.require_safe_negotiation" = true;
    "security.webauthn.always_allow_direct_attestation" = false;
    "signon.autofillForms" = false;

    # interface
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = false;
    "network.connectivity-service.enabled" = false;

    # misc
    "browser.contentanalysis.default_result" = 0;
    "browser.contentanalysis.enabled" = false;
    "browser.download.alwaysOpenPanel" = false;
    "browser.download.always_ask_before_handling_new_types" = true;
    "browser.helperApps.deleteTempFileOnExit" = true;
    "browser.tabs.searchclipboardfor.middleclick" = false;
    "browser.urlbar.showSearchTerms.enabled" = false;
    "devtools.debugger.remote-enabled" = false;
    "extensions.blocklist.enabled" = true;
    "extensions.postDownloadThirdPartyPrompt" = false;
    "extensions.quarantinedDomains.enabled" = true;
    "extensions.webcompat-reporter.enabled" = false;
    "extensions.webcompat.enable_shims" = true;
    "network.http.referer.spoofSource" = false;
    "pdfjs.disabled" = false;
    "privacy.firstparty.isolate" = false;
    "security.dialog_enable_delay" = 1000;
    "security.tls.version.enable-deprecated" = false;
  };
}
