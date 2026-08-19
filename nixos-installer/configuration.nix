{pkgs, ...}: {
  networking.hostName = "nixos";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;
  programs.ssh.startAgent = true;

  users.users.rebiz = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "changeme";
  };

  environment.systemPackages = with pkgs; [git nano curl];

  system.stateVersion = "26.11";
}
