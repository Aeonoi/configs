# Gnome Desktop Environment
{ config, lib, pkgs, ... }:

{
  options = {
    gnome.enable = lib.mkEnableOption "enables Gnome DE";
  };

  config = lib.mkIf config.gnome.enable {
    services.displayManager.gdm.enable = true;

    # Disables the default Gnome packages, we install necessary manually
    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    services.desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [ pkgs.mutter ]; 
      extraGSettingsOverrides = ''
        [org.gnome.mutter.wayland]
        xwayland-scaling-factor=uint32 1
      '';
    };

    environment.systemPackages = with pkgs; [
      nautilus
      papers
      loupe

      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.vitals
      gnomeExtensions.tiling-assistant
      gnomeExtensions.dash-to-dock
      gnome-tweaks
    ];

    security.pam.services = {
      gdm.enableGnomeKeyring = true;
    };
  };
}
