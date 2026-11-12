# Desktop-specific configuration (stationary machines)
{ config, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./kde.nix
    ./hyprland.nix
    ./sway.nix
  ];

  # Enable desktop environment that you want
  # Best to just keep one to avoid conflicting config, themes, etc
  gnome.enable = false;
  kde.enable = true;
  hyprland.enable = false;
  sway.enable = false;
}
