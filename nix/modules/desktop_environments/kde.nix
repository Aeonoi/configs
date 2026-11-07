# KDE Desktop Environment
{ config, lib, pkgs, ... }:

{
  options = {
    kde.enable = lib.mkEnableOption "enables KDE DE";
  };

  config = lib.mkIf config.kde.enable {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
    ];

    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "flover";
    };
  };
}
