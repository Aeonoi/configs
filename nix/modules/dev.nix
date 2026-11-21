# Development environment
{
  config,
  lib,
  pkgs,
  ...
}:

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
    gcc
    clang-tools
    valgrind
    gdb
    gnumake

    nodejs

    openjdk

    python3
    ruff
    basedpyright

    cargo
    rustup

    nil
    texlab
    bash-language-server
    lua-language-server
  ];

  # Make uv able to execute Python (and more)
  programs.nix-ld.enable = true;

  home-manager.useGlobalPkgs = true;
}
