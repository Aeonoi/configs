{ config, pkgs, ...}:

let 
  cpuPowerScript = pkgs.writeShellScript "cpu-power-manager-script" ''
    RAPL_DIR="/sys/class/powercap/intel-rapl:0"
    AC_STATUS=$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo 1)

    if [ "$AC_STATUS" -eq 0 ]; then
      echo "Switching to Battery Mode..."
      
      # Max CPU performance to 30%
      if [ -f /sys/devices/system/cpu/intel_pstate/max_perf_pct ]; then
        echo 30 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
      fi

      # Battery PL1 (15W), PL1 Window (10s), and PL2 (25W)
      if [ -d "$RAPL_DIR" ]; then
        echo $(( 15 * 1000000 )) > "$RAPL_DIR/constraint_0_power_limit_uw"
        echo 10000000 > "$RAPL_DIR/constraint_0_time_window_us"
        echo $(( 25 * 1000000 )) > "$RAPL_DIR/constraint_1_power_limit_uw"
      fi
    else
      echo "Switching to AC Mode..."
      
      # Max CPU performance to 75%
      if [ -f /sys/devices/system/cpu/intel_pstate/max_perf_pct ]; then
        echo 75 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
      fi

      # Battery PL1 (55W), PL1 Window (10s), and PL2 (135W)
      if [ -d "$RAPL_DIR" ]; then
        echo $(( 55 * 1000000 )) > "$RAPL_DIR/constraint_0_power_limit_uw"
        echo 10000000 > "$RAPL_DIR/constraint_0_time_window_us"
        echo $(( 135 * 1000000 )) > "$RAPL_DIR/constraint_1_power_limit_uw"
      fi
    fi
  '';
in
{
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ACTION=="change", RUN+="${cpuPowerScript}"
  '';

  # 3. Run the script via a systemd service on boot
  systemd.services.cpu-power-manager = {
    description = "Apply CPU performance and RAPL power limits via script";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${cpuPowerScript}";
      Restart = "on-failure";
    };
  };
}
