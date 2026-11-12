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
      # extraGSettingsOverridePackages = [ pkgs.mutter ]; 
      # extraGSettingsOverrides = ''
      #   [org.gnome.mutter.wayland]
      #   xwayland-scaling-factor=uint32 1
      # '';
    };

    environment.sessionVariables = {
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "48";
    };

    environment.systemPackages = with pkgs; [
      nautilus
      papers
      loupe

      ghostty

      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.vitals
      gnomeExtensions.dash-to-dock
      gnome-tweaks
    ];

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

        home.activation.fixSteamIcons = ''
          for f in ~/.local/share/applications/*.desktop; do
            [ -f "$f" ] || continue
            id=$(grep -Eo 'steam://rungameid/[0-9]+' "$f" | sed 's#.*/##') || true
            [ -n "$id" ] || continue
            last=$(tail -n1 "$f" || true)
            want="StartupWMClass=steam_app_$id"
            [ "$last" = "$want" ] || echo "$want" >> "$f"
          done
        '';

        home.stateVersion = "26.05";
      };
  };
}
