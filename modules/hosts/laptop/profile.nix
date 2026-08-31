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
      system-services
      containers
      desktop
      brave
      fonts
      gaming
      greeter
      persistence
      tools
    ];
  };
}
