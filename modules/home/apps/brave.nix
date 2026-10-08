let
  bitwarden = "nngceckbapebfimnlniiiahkandclblb";
  darkReader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
  sponsorBlock = "mnjggcdmjocbbbhaepdhchncahnbgone";
  blackHoleTheme = "faeadnfmdfamenfhaipofoffijhlnkif";
  vimiumC = "hfjbmagddngcpeloejdejnfgbamkjaeg";
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
        {id = vimiumC;}
      ];
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--disk-cache-size=1073741824"
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,ParallelDownloading,AsyncDns,BackForwardCache,Prerender2,SpeculativeServiceWorkerWarmUp,TabHoverCardImages"
        "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
      ];
    };
  };
}
