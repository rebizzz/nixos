{inputs, ...}: {
  flake.modules.nixos.laptop-profile = {
    imports = with inputs.self.modules.nixos; [
      base
      boot
      power
      audio
      display
      gpu
      network
      firewall
      tailscale
      system-services
      containers
      desktop
      fonts
      gaming
      greeter
      persistence
      tools
    ];
  };
}
