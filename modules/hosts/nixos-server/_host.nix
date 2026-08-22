_: {
  hostName = "nixos-server";
  sshUser = "rebiz";

  hostId = "8425e349";

  timeZone = "Asia/Kolkata";

  disks = {
    system = "/dev/sda";
    zfsMirror = ["/dev/sdb" "/dev/sdc"];
  };

  wifi.ssid = "ReBiz";
  network.lanIp = "10.42.0.42";

  smartDevices = [
    {
      device = "/dev/disk/by-id/ata-ST500DM002-1BD142_Z6E0EBEW";
      options = "-a -o on -S on -n standby,q -s (S/../.././03|L/../../6/04) -W 4,45,55";
    }
    {
      device = "/dev/disk/by-id/ata-ST3500414CS_6VVEHZ3V";
      options = "-a -o on -S on -n standby,q -s (S/../.././03|L/../../6/04) -W 4,45,55";
    }
  ];

  flakeUri = "git+https://github.com/rebizzz/nixos.git";
}
