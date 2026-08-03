_: {
  flake.modules.nixos.hibernate = _: {
    systemd.sleep.settings.Sleep = {
      HibernateMode = "platform shutdown";
      HibernateDelaySec = "30min";
    };
  };
}
