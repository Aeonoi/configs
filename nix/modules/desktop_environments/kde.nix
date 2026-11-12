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
      # KWIN_DRM_DISABLE_TRIPLE_BUFFERING = "1";
      XCURSOR_THEME = "Breeze";
      XCURSOR_SIZE = "48";
    };

    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "flover";
    };

    security.pam.services.plasma-login-manager.kwallet.enable = true;
    security.pam.services."flover".kwallet.enable = false;

    home-manager.users."flover" = 
      { config, pkgs, ... }:
      {
        home.pointerCursor = {
          enable = true;
          name = "Breeze";
          package = pkgs.kdePackages.breeze-icons;
          size = 48;
          gtk.enable = true;
          x11.enable = true;
        };

        home.stateVersion = "26.05";
      };
  };
}
