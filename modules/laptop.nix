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

  environment.systemPackages = with pkgs; [
    brightnessctl
    dhcpcd
    iw
    wl-mirror
    libinput
  ];
}
