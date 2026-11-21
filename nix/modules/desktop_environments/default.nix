# Desktop-specific configuration (stationary machines)
{ config, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./kde.nix
    ./hyprland.nix
    ./sway.nix
    ./umbriel.nix
  ];

  # Enable desktop environment that you want
  # Best to just keep one to avoid conflicting config, themes, etc
  gnome.enable = false;
  kde.enable = false;
  hyprland.enable = false;
  sway.enable = false;
  umbriel.enable = true;
}
