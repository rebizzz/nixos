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
        "--disk-cache-size=2147483648"
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,ParallelDownloading,AsyncDns"
        "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
      ];
    };
  };
}
