_: {
  flake.modules.nixos.greeter = {
    services.displayManager = {
      defaultSession = "umbriel";
      ly = {
        enable = true;
        settings = {
          default_input = "password";
          save_file_dir = null;
          animation = "none";
          clock = null;
          battery_id = null;
          clear_password = true;
        };
      };
    };
  };
}
