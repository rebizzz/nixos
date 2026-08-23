_: {
  flake.modules.homeManager.sounds = {pkgs, ...}: let
    notifyPlayer = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
    soundService = exec: desc: {
      Unit = {
        Description = desc;
        After = ["pipewire.service" "wireplumber.service"];
      };
      Service = {
        Type = "simple";
        ExecStart = exec;
        Restart = "on-failure";
        RestartSec = "3s";
      };
      Install.WantedBy = ["default.target"];
    };
    udevadm = "${pkgs.systemd}/bin/udevadm";
    upower = "${pkgs.upower}/bin/upower";
    udevMonitor = pkgs.writeShellScript "udev-sound-monitor" ''
      ${udevadm} monitor --udev --subsystem-match=usb --property | while read -r line; do
        case "$line" in
          "ACTION=add"*)
            while read -r prop; do
              [ -z "$prop" ] && break
              if [ "$prop" = "DEVTYPE=usb_device" ]; then
                ${notifyPlayer} -i device-added
                break
              fi
            done
            ;;
          "ACTION=remove"*)
            while read -r prop; do
              [ -z "$prop" ] && break
              if [ "$prop" = "DEVTYPE=usb_device" ]; then
                ${notifyPlayer} -i device-removed
                break
              fi
            done
            ;;
        esac
      done
    '';
    upowerMonitor = pkgs.writeShellScript "upower-sound-monitor" ''
      devices=$(${upower} -e)
      ac=$(echo "$devices" | grep -iE "line_power|ac_adapter|mains" | head -1)
      if [ -n "$ac" ]; then
        prev_online=$(${upower} -i "$ac" | awk '/online:/ {print $2}')
      else
        prev_online=""
      fi
      low_warned=""

      ${upower} --monitor | while read -r _; do
        devices=$(${upower} -e)
        ac=$(echo "$devices" | grep -iE "line_power|ac_adapter|mains" | head -1)
        if [ -n "$ac" ]; then
          online=$(${upower} -i "$ac" | awk '/online:/ {print $2}')
          if [ -n "$online" ] && [ "$online" != "$prev_online" ]; then
            case "$online" in
              yes) ${notifyPlayer} -i power-plug ; low_warned="" ;;
              no)  ${notifyPlayer} -i power-unplug ;;
            esac
            prev_online="$online"
          fi
        fi

        batt=$(echo "$devices" | grep -i battery | head -1)
        if [ -n "$batt" ]; then
          batt_info=$(${upower} -i "$batt")
          pct=$(echo "$batt_info" | awk '/percentage:/ {gsub(/%/,"",$2); print int($2)}')
          st=$(echo "$batt_info" | awk '/state:/ {print $2}')
          if [ "$pct" -le 15 ] && [ "$st" = "discharging" ] && [ -z "$low_warned" ]; then
            ${notifyPlayer} -i battery-low
            low_warned="yes"
          elif [ "$pct" -gt 15 ] || [ "$st" != "discharging" ]; then
            low_warned=""
          fi
        fi
      done
    '';
  in {
    home.packages = with pkgs; [
      sound-theme-freedesktop
    ];

    gtk.gtk3.extraConfig = {
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 1;
      gtk-sound-theme-name = "freedesktop";
    };

    systemd.user.services = {
      udev-sound-monitor = soundService udevMonitor "USB sound events";
      upower-sound-monitor = soundService upowerMonitor "Power sound events";
    };
  };
}
