# Laptop-specific configuration
{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Battery management
  services.upower = {
    enable = true;
    allowRiskyCriticalPowerAction = true;
    criticalPowerAction = "Suspend";
  };

  # Fingerprint reader
  services.fprintd = {
    enable = true;
    # tod = { };
  };

  # Power button shortcuts
  services.logind.settings.Login.HandlePowerKey = "suspend-then-hibernate";
  services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";

  # Better power management with Tuned 
  services.power-profiles-daemon.enable = false;

  services.tuned.enable = true;
  services.tuned.ppdSupport = true;

  # Better power saving mode
  services.tuned.profiles = {
    powersave = {
      cpu = {
        energy_performance_preference = "balance_power";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    dhcpcd
    iw
    wl-mirror
    libinput
  ];
}
