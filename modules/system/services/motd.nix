_: {
  flake.modules.nixos.motd = {pkgs, ...}: let
    motdScript = pkgs.writeShellScript "motd-dashboard" ''
      # Color palette (modern terminal aesthetic)
      c_reset="\033[0m"
      c_bold="\033[1m"
      c_dim="\033[2m"

      c_border="\033[38;5;67m"     # Slate blue border
      c_label="\033[38;5;248m"     # Soft muted gray labels
      c_host="\033[1;38;5;81m"     # Bright cyan bold hostname
      c_os="\033[38;5;244m"        # Subdued OS version
      c_ip="\033[38;5;79m"         # Mint green LAN IP
      c_ts="\033[38;5;216m"        # Soft amber Tailscale IP
      c_green="\033[38;5;78m"      # Calm emerald green
      c_yellow="\033[38;5;221m"    # Warm amber yellow
      c_red="\033[38;5;203m"       # Coral red
      c_gray="\033[38;5;240m"      # Dim gray for unfilled track / standby
      c_cyan="\033[38;5;80m"       # Electric cyan
      c_purple="\033[38;5;141m"    # Soft purple for containers

      w=58
      top="╭"
      sep="├"
      bot="╰"
      for i in $(seq 1 $((w + 2))); do
        top="''${top}─"
        sep="''${sep}─"
        bot="''${bot}─"
      done
      top="''${top}╮"
      sep="''${sep}┤"
      bot="''${bot}╯"

      pad() {
        local str="$1"
        local clean_str
        clean_str=$(printf "%b" "$str" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGK]//g")
        local visible_len=''${#clean_str}
        local pad_len=$(( w - visible_len ))
        if [ "$pad_len" -gt 0 ]; then
          printf "%b%*s" "$str" "$pad_len" ""
        else
          printf "%b" "$str"
        fi
      }

      draw_bar() {
        local pct=$1
        local filled=$(( (pct * 16) / 100 ))
        [ "$filled" -gt 16 ] && filled=16
        [ "$filled" -lt 0 ] && filled=0
        local unfilled=$(( 16 - filled ))

        local color="$c_green"
        [ "$pct" -ge 70 ] && color="$c_yellow"
        [ "$pct" -ge 85 ] && color="$c_red"

        local f_str=""
        local u_str=""
        for i in $(seq 1 $filled 2>/dev/null); do f_str="█$f_str"; done
        for i in $(seq 1 $unfilled 2>/dev/null); do u_str="░$u_str"; done
        printf "%b%s%b%s%b" "$color" "$f_str" "$c_gray" "$u_str" "$c_reset"
      }

      fmt_temp() {
        local temp=$1
        [ -z "$temp" ] && return
        if [ "$temp" -ge 80 ]; then
          printf "%b%d°C%b" "$c_red" "$temp" "$c_reset"
        elif [ "$temp" -ge 60 ]; then
          printf "%b%d°C%b" "$c_yellow" "$temp" "$c_reset"
        else
          printf "%b%d°C%b" "$c_green" "$temp" "$c_reset"
        fi
      }

      fmt_bytes() {
        local b=$1
        if [ "$b" -ge 1099511627776 ]; then
          awk "BEGIN{printf \"%.1fT\", $b/1099511627776}"
        elif [ "$b" -ge 1073741824 ]; then
          awk "BEGIN{printf \"%.1fG\", $b/1073741824}"
        else
          awk "BEGIN{printf \"%.0fM\", $b/1048576}"
        fi
      }

      row_label() {
        local lbl="$1"
        printf "%b%-15s%b" "$c_label" "$lbl" "$c_reset"
      }

      row_bar() {
        local lbl="$1"
        local pct="$2"
        local used="$3"
        local size="$4"
        printf "%s[%b] %6s / %-6s (%2d%%)" "$(row_label "$lbl")" "$(draw_bar "$pct")" "$used" "$size" "$pct"
      }

      row() {
        local content="$1"
        printf "%b│%b %s %b│%b\n" "$c_border" "$c_reset" "$(pad "$content")" "$c_border" "$c_reset"
      }

      # --- System & CPU ---
      hostname="$(hostname)"

      os_ver=""
      if [ -f /etc/os-release ]; then
        os_ver=$(awk -F= '/^PRETTY_NAME/{gsub(/"/,"",$2); print $2}' /etc/os-release 2>/dev/null)
      fi
      [ -z "$os_ver" ] && os_ver="NixOS"

      uptime_sec=$(cut -d. -f1 /proc/uptime 2>/dev/null)
      [ -n "$uptime_sec" ] || uptime_sec=0
      days=$(( uptime_sec / 86400 ))
      hours=$(( (uptime_sec % 86400) / 3600 ))
      mins=$(( (uptime_sec % 3600) / 60 ))
      if [ "$days" -gt 0 ]; then
        uptime_str="''${days}d ''${hours}h ''${mins}m"
      elif [ "$hours" -gt 0 ]; then
        uptime_str="''${hours}h ''${mins}m"
      else
        uptime_str="''${mins}m"
      fi

      load_avg="$(awk '{print $1 ", " $2 ", " $3}' /proc/loadavg 2>/dev/null)"

      # CPU Temperature Detection
      cpu_temp=""
      for h in /sys/class/hwmon/hwmon*; do
        [ -d "$h" ] || continue
        name=$(cat "$h/name" 2>/dev/null)
        case "$name" in
          coretemp|k10temp|zenpower|cpu_thermal|soc_thermal|cpu-thermal)
            for t in "$h"/temp*_input; do
              [ -f "$t" ] || continue
              t_base="''${t%_input}"
              label=$(cat "''${t_base}_label" 2>/dev/null)
              case "$label" in
                "Package id 0"|"Tctl"|"Tdie"|"CPU"|"")
                  val=$(cat "$t" 2>/dev/null)
                  if [ -n "$val" ] && [ "$val" -gt 0 ]; then
                    cpu_temp=$(( val / 1000 ))
                    break 2
                  fi
                  ;;
              esac
            done
            ;;
        esac
      done
      if [ -z "$cpu_temp" ]; then
        for tz in /sys/class/thermal/thermal_zone*; do
          [ -d "$tz" ] || continue
          type=$(cat "$tz/type" 2>/dev/null)
          case "$type" in
            *pkg*|*x86_pkg_temp*|*cpu*|*soc*|*acpitz*|*TCPU*)
              val=$(cat "$tz/temp" 2>/dev/null)
              if [ -n "$val" ] && [ "$val" -gt 0 ]; then
                cpu_temp=$(( val / 1000 ))
                break
              fi
              ;;
          esac
        done
      fi

      # --- Network ---
      lan_ip="$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}')"
      [ -n "$lan_ip" ] || lan_ip="offline"

      ts_ip="$(${pkgs.tailscale}/bin/tailscale ip -4 2>/dev/null)"
      [ -n "$ts_ip" ] || ts_ip="disconnected"

      # --- Memory & Swap ---
      mem_total=$(awk '/MemTotal/{print $2}' /proc/meminfo 2>/dev/null)
      mem_avail=$(awk '/MemAvailable/{print $2}' /proc/meminfo 2>/dev/null)
      [ -n "$mem_total" ] || mem_total=1
      [ -n "$mem_avail" ] || mem_avail=0
      mem_used=$(( (mem_total - mem_avail) / 1024 ))
      mem_total_mb=$(( mem_total / 1024 ))
      mem_pct=0
      [ "$mem_total_mb" -gt 0 ] && mem_pct=$(( (mem_used * 100) / mem_total_mb ))

      swap_total=$(awk '/SwapTotal/{print $2}' /proc/meminfo 2>/dev/null)
      swap_free=$(awk '/SwapFree/{print $2}' /proc/meminfo 2>/dev/null)
      [ -n "$swap_total" ] || swap_total=1
      [ -n "$swap_free" ] || swap_free=1
      swap_used=$(( (swap_total - swap_free) / 1024 ))
      swap_total_mb=$(( swap_total / 1024 ))
      swap_pct=0
      [ "$swap_total_mb" -gt 0 ] && swap_pct=$(( (swap_used * 100) / swap_total_mb ))

      # --- Disk Usage ---
      root_target="/"
      if df -T / 2>/dev/null | grep -q tmpfs; then
        if [ -d /persistent ] && df /persistent >/dev/null 2>&1; then
          root_target="/persistent"
        elif [ -d /nix ] && df /nix >/dev/null 2>&1; then
          root_target="/nix"
        fi
      fi

      disk_root_pct=$(df -P "$root_target" 2>/dev/null | awk 'NR==2{sub(/%/,"",$5); print $5}')
      disk_root_used=$(df -h -P "$root_target" 2>/dev/null | awk 'NR==2{print $3}')
      disk_root_size=$(df -h -P "$root_target" 2>/dev/null | awk 'NR==2{print $2}')
      [ -n "$disk_root_pct" ] || disk_root_pct=0

      # ZFS Pools Usage
      zfs_lines=()
      if command -v zpool >/dev/null 2>&1; then
        while read -r p_name p_size p_alloc p_health; do
          [ -n "$p_name" ] || continue
          if [ "$p_size" -gt 0 ] 2>/dev/null; then
            p_pct=$(( (p_alloc * 100) / p_size ))
            u_str=$(fmt_bytes "$p_alloc")
            s_str=$(fmt_bytes "$p_size")
            zfs_lines+=("$p_name|$p_pct|$u_str|$s_str|$p_health")
          fi
        done < <(zpool list -H -p -o name,size,alloc,health 2>/dev/null || true)
      fi

      # --- Physical Disks / HDD Temps & Standby ---
      drive_entries=()
      for b in /sys/block/sd* /sys/block/nvme*n1 /sys/block/vd*; do
        [ -e "$b" ] || continue
        dev_name=$(basename "$b")
        rot=$(cat "$b/queue/rotational" 2>/dev/null)
        b_dev_link=$(readlink -f "$b/device" 2>/dev/null)

        d_type="SSD"
        [ "$rot" = "1" ] && d_type="HDD"
        [[ "$dev_name" =~ nvme ]] && d_type="NVMe"

        d_state="active"
        if [ "$rot" = "1" ]; then
          if command -v hdparm >/dev/null 2>&1; then
            h_out=$(hdparm -C "/dev/$dev_name" 2>/dev/null)
            if echo "$h_out" | grep -qi "standby"; then
              d_state="standby"
            elif echo "$h_out" | grep -qi "sleeping"; then
              d_state="sleep"
            fi
          elif [ -x "${pkgs.hdparm}/bin/hdparm" ]; then
            h_out=$("${pkgs.hdparm}/bin/hdparm" -C "/dev/$dev_name" 2>/dev/null)
            if echo "$h_out" | grep -qi "standby"; then
              d_state="standby"
            elif echo "$h_out" | grep -qi "sleeping"; then
              d_state="sleep"
            fi
          fi
        fi

        d_temp=""
        if [ "$d_state" = "active" ]; then
          # NVMe hwmon
          if [[ "$dev_name" =~ nvme([0-9]+) ]]; then
            n_idx="''${BASH_REMATCH[1]}"
            for h in /sys/class/hwmon/hwmon*; do
              [ -d "$h" ] || continue
              if [ "$(cat "$h/name" 2>/dev/null)" = "nvme" ]; then
                d_link=$(readlink -f "$h/device" 2>/dev/null)
                if [[ "$d_link" =~ nvme''${n_idx} ]] || [ -z "$n_idx" ]; then
                  v=$(cat "$h/temp1_input" 2>/dev/null)
                  [ -n "$v" ] && d_temp=$(( v / 1000 ))
                  break
                fi
              fi
            done
          fi

          # drivetemp hwmon for SATA drives (match SCSI target or device link)
          if [ -z "$d_temp" ] && [[ "$dev_name" =~ sd[a-z] ]]; then
            for h in /sys/class/hwmon/hwmon*; do
              [ -d "$h" ] || continue
              if [ "$(cat "$h/name" 2>/dev/null)" = "drivetemp" ]; then
                h_dev_link=$(readlink -f "$h/device" 2>/dev/null)
                if [ -n "$b_dev_link" ] && [ "$b_dev_link" = "$h_dev_link" ] || [ -d "$h/device/$dev_name" ] || [ -d "$h/device/block/$dev_name" ]; then
                  v=$(cat "$h/temp1_input" 2>/dev/null)
                  [ -n "$v" ] && d_temp=$(( v / 1000 ))
                  break
                fi
              fi
            done
          fi

          # smartctl fallback (with -n standby so we never wake spun-down disks)
          if [ -z "$d_temp" ]; then
            smartctl_bin=""
            if command -v smartctl >/dev/null 2>&1; then
              smartctl_bin="smartctl"
            elif [ -x "${pkgs.smartmontools}/bin/smartctl" ]; then
              smartctl_bin="${pkgs.smartmontools}/bin/smartctl"
            fi
            if [ -n "$smartctl_bin" ]; then
              d_temp=$($smartctl_bin -n standby -A "/dev/$dev_name" 2>/dev/null | awk '
                /Temperature_Celsius|Airflow_Temperature_Cel|Current Drive Temperature|Temperature:/ {
                  for(i=1;i<=NF;i++) {
                    if ($i ~ /^[0-9]+$/ && $i > 0 && $i < 120) { val=$i }
                  }
                }
                END { if (val) print val }
              ')
            fi
          fi
        fi

        entry="''${dev_name} (''${d_type}):"
        if [ "$d_state" = "standby" ] || [ "$d_state" = "sleep" ]; then
          entry="''${entry} ''${c_gray}[standby]''${c_reset}"
        elif [ -n "$d_temp" ]; then
          entry="''${entry} $(fmt_temp "$d_temp")"
        else
          entry="''${entry} ''${c_green}[active]''${c_reset}"
        fi
        drive_entries+=("$entry")
      done

      # --- Services ---
      docker_count=0
      if command -v docker >/dev/null 2>&1; then
        docker_count=$(docker ps -q 2>/dev/null | wc -l)
      elif command -v podman >/dev/null 2>&1; then
        docker_count=$(podman ps -q 2>/dev/null | wc -l)
      fi

      # --- Issues Check ---
      issues=""
      failed=$(systemctl --failed --no-legend --plain 2>/dev/null | wc -l)
      if [ "$failed" -gt 0 ]; then
        issues="$issues\n  $c_red✗ $failed failed systemd unit(s) (systemctl --failed)$c_reset"
      fi

      if [ ''${#zfs_lines[@]} -gt 0 ]; then
        for line in "''${zfs_lines[@]}"; do
          IFS="|" read -r p_name p_pct u_str s_str p_health <<< "$line"
          if [ -n "$p_health" ] && [ "$p_health" != "ONLINE" ]; then
            issues="$issues\n  $c_red✗ ZFS pool '$p_name' is $p_health (zpool status $p_name)$c_reset"
          fi
        done
      fi

      last_upgrade=$(systemctl show nixos-upgrade.service -p Result --value 2>/dev/null)
      if [ -n "$last_upgrade" ] && [ "$last_upgrade" != "success" ] && [ "$last_upgrade" != "" ]; then
        issues="$issues\n  $c_yellow! Last auto-upgrade: $last_upgrade (journalctl -u nixos-upgrade)$c_reset"
      fi

      # ==================== RENDER ====================
      printf "\n"
      printf "%b%s%b\n" "$c_border" "$top" "$c_reset"

      # System Header
      row "$(row_label "System:")$(printf "%b%s%b %b(%s)%b" "$c_host" "$hostname" "$c_reset" "$c_os" "$os_ver" "$c_reset")"
      row "$(row_label "Uptime:")$uptime_str"
      if [ -n "$cpu_temp" ]; then
        row "$(row_label "CPU Temp:")$(fmt_temp "$cpu_temp")"
      fi
      row "$(row_label "Load:")$load_avg"

      printf "%b%s%b\n" "$c_border" "$sep" "$c_reset"

      # Network
      row "$(row_label "LAN IP:")$(printf "%b%s%b" "$c_ip" "$lan_ip" "$c_reset")"
      row "$(row_label "Tailscale:")$(printf "%b%s%b" "$c_ts" "$ts_ip" "$c_reset")"

      printf "%b%s%b\n" "$c_border" "$sep" "$c_reset"

      # Resources (Memory & Swap)
      row "$(row_bar "RAM:" "$mem_pct" "''${mem_used}M" "''${mem_total_mb}M")"
      row "$(row_bar "Swap:" "$swap_pct" "''${swap_used}M" "''${swap_total_mb}M")"

      # Storage Pools / Disks
      row "$(row_bar "Disk (/):" "$disk_root_pct" "$disk_root_used" "$disk_root_size")"
      if [ ''${#zfs_lines[@]} -gt 0 ]; then
        for line in "''${zfs_lines[@]}"; do
          IFS="|" read -r p_name p_pct u_str s_str p_health <<< "$line"
          row "$(row_bar "ZFS ($p_name):" "$p_pct" "$u_str" "$s_str")"
        done
      fi

      # Physical Drives / HDDs Status & Temps
      if [ ''${#drive_entries[@]} -gt 0 ]; then
        first=1
        curr_line=""
        for d_entry in "''${drive_entries[@]}"; do
          if [ -z "$curr_line" ]; then
            curr_line="$d_entry"
          else
            test_combined="$curr_line   $d_entry"
            clean_test=$(printf "%b" "$test_combined" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGK]//g")
            if [ ''${#clean_test} -le $(( w - 15 )) ]; then
              curr_line="$test_combined"
            else
              if [ $first -eq 1 ]; then
                row "$(row_label "Drives:")$curr_line"
                first=0
              else
                row "$(row_label "")$curr_line"
              fi
              curr_line="$d_entry"
            fi
          fi
        done
        if [ -n "$curr_line" ]; then
          if [ $first -eq 1 ]; then
            row "$(row_label "Drives:")$curr_line"
          else
            row "$(row_label "")$curr_line"
          fi
        fi
      fi

      printf "%b%s%b\n" "$c_border" "$sep" "$c_reset"

      # Services & Status
      row "$(row_label "Docker:")$(printf "%b%d%b container(s) running" "$c_purple" "$docker_count" "$c_reset")"
      if [ -z "$issues" ]; then
        row "$(row_label "Status:")$(printf "%bAll services & storage healthy%b" "$c_green" "$c_reset")"
      fi

      printf "%b%s%b\n" "$c_border" "$bot" "$c_reset"

      if [ -n "$issues" ]; then
        printf "%b\n\n" "$issues"
      else
        printf "\n"
      fi
    '';
  in {
    environment.interactiveShellInit = "${motdScript}";
    programs.fish.interactiveShellInit = ''
      set -g fish_greeting ""
      ${motdScript}
    '';
  };
}
