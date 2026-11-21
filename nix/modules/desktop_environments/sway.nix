# Sway with Waybar
{ config, lib, pkgs, ... }:

{
  options = {
    sway.enable = lib.mkEnableOption "enables sway";
  };

  config = lib.mkIf config.sway.enable {
    # services.displayManager.noctalia-greeter.enable = true;
    programs.noctalia.enable = true;
    services.displayManager.noctalia-greeter.enable = true;

    programs.sway = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      j4-dmenu-desktop
      ranger
      alacritty
      zathura
      imv
      poppler-utils
      waybar
    ];


    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    security.pam.services = {
      greetd.enableGnomeKeyring = true;
    };

    home-manager.users."flover" =
    { config,pkgs,...}:
    {
      programs.noctalia = {
        enable = true;
        settings = {
          shell = {
            # font = "JetBrains Nerd Font Mono";
            polkit_agent = true;
          };
          location = {
            auto_locate = false;
            custom_schedule = true;
            sunset = "18:00";
            sunrise = "08:00";
          };
          nightlight = {
            enabled = true;
            temperature_day = 6500;
            temperature_night = 3500;
          };
          bar.default = {
            position = "bottom";
            start = ["launcher" "wallpaper" "workspaces"];
            center = ["control-center" "clock" "media"];
            end = ["tray" "notifications" "network" "bluetooth" "volume" "brightness" "battery" "session"];
          };
        };
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "application/xps" = [ "org.pwmt.zathura.desktop" ];
          "application/vnd.ms-xpsdocument" = [ "org.pwmt.zathura.desktop" ];
          "image/gif" = [ "imv.desktop" ];
          "image/jpeg" = [ "imv.desktop" ];
          "image/jpg" = [ "imv.desktop" ];
          "image/png" = [ "imv.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "text/html" = [ "firefox.desktop" ];
          "text/plain" = [ "nvim.desktop" ];
        };
      };

      home.stateVersion = "26.05";
    };

  };
}

