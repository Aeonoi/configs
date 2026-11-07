# Personal user configuration (GUI + personal services)
{
  config,
  pkgs,
  ...
}:

{
  imports = [
  ];

  home-manager.users."flover" =
    { config, pkgs, ... }:
    {

      # GUI configuration
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

      programs.alacritty = {
        enable = true;
        settings =
          let
            toml = builtins.readFile ../../../config/.config/alacritty/alacritty.toml;
          in
          builtins.fromTOML toml;
      };

      programs.firefox = {
        enable = true;
      };

      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
        gtk.enable = true;
        sway.enable = true;
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            text-scaling-factor = 1;
          };
          "org/gnome/mutter/wayland" = { 
            xwayland-scaling-factor = 1;
          };
        };
      };
    };
}
