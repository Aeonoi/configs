# Desktop-specific configuration (stationary machines)
{ config, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./kde.nix
  ];

  # Enable desktop environment that you want
  # Best to just keep one to avoid conflicting config, themes, etc
  gnome.enable = true;
  kde.enable = false;
}
