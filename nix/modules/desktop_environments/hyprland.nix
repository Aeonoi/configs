{ config, lib, pkgs, ... }:

{
  options = {
    hyprland.enable = lib.mkEnableOption "enables Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    environment.systemPackages = with pkgs; [
      ranger
      alacritty
      zathura
      imv
      poppler-utils
    ];

    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;

    home-manager.users."flover" = { config, pkgs, ... }: {
      # Enable and configure Noctalia fully in Home Manager
      programs.noctalia = {
        enable = true;
        settings = {
          shell = {
            font = "JetBrains Nerd Font Mono";
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

      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = builtins.readFile ../../../config/.config/hypr/hyprland.lua;
      };

      home.sessionVariables = {
        BROWSER = "firefox";
        XCURSOR_SIZE = "48";
        GDK_BACKEND = "wayland,x11";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XWAYLAND_DPI = "192";
      };

      home.file.".Xresources".text = ''
        Xft.dpi: 192
      '';

      # xdg.mimeApps = {
      #   enable = true;
      #   defaultApplications = {
      #     "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      #     "application/xps" = [ "org.pwmt.zathura.desktop" ];
      #     "application/vnd.ms-xpsdocument" = [ "org.pwmt.zathura.desktop" ];
      #     "image/gif" = [ "imv.desktop" ];
      #     "image/jpeg" = [ "imv.desktop" ];
      #     "image/jpg" = [ "imv.desktop" ];
      #     "image/png" = [ "imv.desktop" ];
      #     "x-scheme-handler/http" = [ "firefox.desktop" ];
      #     "x-scheme-handler/https" = [ "firefox.desktop" ];
      #     "text/html" = [ "firefox.desktop" ];
      #     "text/plain" = [ "nvim.desktop" ];
      #   };
      # };

      home.stateVersion = "26.05";
    };
  };
}
