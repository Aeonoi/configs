# Hyprland DE with Noctalia shell and Noctalia greeter
{ config, lib, pkgs, ... }:

{
  options = {
    hyprland.enable = lib.mkEnableOption "enables Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    services.displayManager.noctalia-greeter.enable = true;

    programs.noctalia.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # programs.noctalia.settings = { 
    #   shell = {
    #     font = "Noto Sans Mono";
    #     polkit_agent = true;
    #   };
    #   location = {
    #     auto_locate = false;
    #     custom_schedule = true;
    #     sunset = "18:00";
    #     sunrise = "08:00";
    #   };
    #   nightlight = {
    #     enabled = true;
    #     temperature_day = 6500;
    #     temperature_night = 3500;
    #   };
    #   bar.default = {
    #     position = "bottom";
    #     start = ["launcher" "wallpaper" "workspaces"];
    #     center = ["control-center" "clock" "media"];
    #     end = ["tray" "notifications" "network" "bluetooth" "volume" "brightness" "battery"  "session"];
    #   };
    # };

    environment.systemPackages = with pkgs; [
      # j4-dmenu-desktop
      ranger
      alacritty
    ];
  };
}
