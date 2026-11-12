# Sway with Waybar
{ config, lib, pkgs, ... }:

{
  options = {
    sway.enable = lib.mkEnableOption "enables sway";
  };

  config = lib.mkIf config.sway.enable {
    # services.displayManager.noctalia-greeter.enable = true;
    programs.noctalia.enable = true;

    programs.sway = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      # j4-dmenu-desktop
      ranger
      alacritty
      zathura
      imv
      poppler-utils
    ];

    services.getty = {
      autologinUser = "flover";
      autologinOnce = true;
    };

    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    security.pam.services = {
      greetd.enableGnomeKeyring = true;
    };


    home-manager.users."flover" =
    { config,pkgs,...}:
    {
      home.stateVersion = "26.05";
    };

  };
}

