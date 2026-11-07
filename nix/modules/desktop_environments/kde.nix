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

    security = {
      # If enabled, pam_wallet will attempt to automatically unlock the user’s default KDE wallet upon login.
      # If the user has no wallet named “kdewallet”, or the login password does not match their wallet password,
      # KDE will prompt separately after login.
      pam = {
        services = {
          "flover" = {
            kwallet = {
              enable = true;
              package = pkgs.kdePackages.kwallet-pam;
            };
          };
        };
      };
    };
  };
}
