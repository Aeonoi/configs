# KDE Desktop Environment
{ config, lib, pkgs, ... }:

{
  options = {
    kde.enable = lib.mkEnableOption "enables KDE DE";
  };

  config = lib.mkIf config.kde.enable {
    services.displayManager.sddm.enable = false;
    services.displayManager.plasma-login-manager.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
    ];

    environment.sessionVariables = {
      KWIN_DRM_DISABLE_TRIPLE_BUFFERING = "1";
    };

    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "flover";
    };

    security.pam.services.plasma-login-manager.kwallet.enable = true;
    security.pam.services."flover".kwallet.enable = false;
  };
}
