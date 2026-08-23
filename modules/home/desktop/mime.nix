_: let
  web = "brave-browser.desktop";
  image = "org.gnome.Loupe.desktop";
  av = "mpv.desktop";
  doc = "org.gnome.Papers.desktop";
  archive = "org.gnome.FileRoller.desktop";
  files = "org.gnome.Nautilus.desktop";
  text = "nano-text-editor.desktop";
in {
  flake.modules.homeManager.mime = _: {
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
      };
      mime.enable = true;
      desktopEntries.nano-text-editor = {
        name = "Nano (Kitty)";
        exec = "kitty nano %f";
        terminal = false;
        type = "Application";
        mimeType = ["text/plain" "text/markdown" "application/json"];
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = files;
          "text/plain" = text;
          "text/markdown" = text;
          "application/json" = text;
          "text/html" = web;
          "application/xhtml+xml" = web;
          "x-scheme-handler/http" = web;
          "x-scheme-handler/https" = web;
          "x-scheme-handler/about" = web;
          "x-scheme-handler/unknown" = web;
          "image/png" = image;
          "image/jpeg" = image;
          "image/gif" = image;
          "image/webp" = image;
          "image/bmp" = image;
          "image/tiff" = image;
          "image/svg+xml" = image;
          "image/heif" = image;
          "image/heic" = image;
          "image/avif" = image;
          "image/jxl" = image;
          "image/x-icon" = image;
          "application/pdf" = doc;
          "application/postscript" = doc;
          "application/epub+zip" = doc;
          "image/vnd.djvu" = doc;
          "application/zip" = archive;
          "application/x-tar" = archive;
          "application/gzip" = archive;
          "application/x-compressed-tar" = archive;
          "application/x-bzip2" = archive;
          "application/x-bzip-compressed-tar" = archive;
          "application/x-xz" = archive;
          "application/x-xz-compressed-tar" = archive;
          "application/x-7z-compressed" = archive;
          "application/vnd.rar" = archive;
          "application/x-rar-compressed" = archive;
          "video/mp4" = av;
          "video/x-matroska" = av;
          "video/webm" = av;
          "video/quicktime" = av;
          "video/x-msvideo" = av;
          "video/mpeg" = av;
          "video/x-flv" = av;
          "video/3gpp" = av;
          "video/ogg" = av;
          "audio/mpeg" = av;
          "audio/flac" = av;
          "audio/wav" = av;
          "audio/x-wav" = av;
          "audio/ogg" = av;
          "audio/aac" = av;
          "audio/mp4" = av;
          "audio/x-m4a" = av;
          "audio/opus" = av;
        };
      };
    };
  };
}
