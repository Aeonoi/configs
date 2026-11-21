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
    };

    environment.sessionVariables = {
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "48";
    };

    environment.systemPackages = with pkgs; [
      nautilus
      papers
      loupe

      # ghostty
      ptyxis # "new" gnome-terminal

      # Themes the app titlebars
      qadwaitadecorations
      qadwaitadecorations-qt6
      # Themes the apps
      qgnomeplatform
      qgnomeplatform-qt6

      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.tiling-assistant
      gnomeExtensions.vitals
      gnomeExtensions.dash-to-panel
      gnomeExtensions.dash-to-dock
      gnomeExtensions.just-perfection
      gnome-tweaks
    ];

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    security.pam.services = {
      gdm.enableGnomeKeyring = true;
    };

    services.gnome.gnome-keyring.enable = true;

    home-manager.users."flover" = 
      { config, pkgs, ... }:
      {
        home.pointerCursor = {
          enable = true;
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 48;
          gtk.enable = true;
          x11.enable = true;
        };

        dconf = {
          enable = true;
          settings = {
            "org/gnome/desktop/interface" = {
              text-scaling-factor = 1;
              icon-theme = "Adwaita";
            };
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              enable-hot-corners = false;
            };
            # "org/gnome/mutter/wayland" = { 
            #   xwayland-scaling-factor = 1;
            # };
          };
        };

        home.stateVersion = "26.05";
      };
  };
}
