# KDE Desktop Environment
{ config, lib, pkgs, ... }:

{
  options = {
    gnome.enable = lib.mkEnableOption "enables Gnome DE";
  };

  config = lib.mkIf config.gnome.enable {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
    ];

    security.pam.services = {
      sddm.enableGnomeKeyring = true;
    };
  };
}
