{inputs, ...}: {
  flake.modules.nixos.laptop-profile = {
    imports = with inputs.self.modules.nixos; [
      base
      audio
      boot
      brave-policy
      cachyos-tuning
      containers
      desktop
      display
      fonts
      gaming
      gpu
      hibernate
      lock-before-sleep
      nano
      network
      noctalia-greeter
      persistence
      power
      services
      tools
    ];
  };
}
