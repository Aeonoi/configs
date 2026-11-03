# Development environment
{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  # Configure Docker, but don't auto-start it.
  virtualisation.docker.enable = true;
  systemd.services.docker.wantedBy = lib.mkForce [ ];

  # Add audio/video groups
  users.users."flover".extraGroups = [
    "docker"
  ];

  environment.systemPackages = with pkgs; [
    cargo
    gcc
    gdb
    gnumake
    nodejs
    openjdk
    python3
    rustup
    valgrind
  ];

  # Make uv able to execute Python (and more)
  programs.nix-ld.enable = true;

  home-manager.useGlobalPkgs = true;
}
