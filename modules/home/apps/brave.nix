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
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--disk-cache-size=1073741824"
        # AsyncDns: glibc getaddrinfo never returns HTTPS records, so ECH dies without it
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,ParallelDownloading,AsyncDns"
        "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
      ];
    };
  };
}
