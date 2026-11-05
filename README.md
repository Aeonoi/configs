# Configs 

## Dotfiles

Managed and handled by `stow`

## NixOS 

### Enable flakes

### Build/Upgrade

The directory is optional (will default to `/etc/nixos/`). But optimally, the directory will be pointed to where your Nix config is located.

#### With flakes

To build: 

`sudo nixos-rebuild switch --flake .`

To update/upgrade: 

This should update the flake.lock file and rebuilds a new generation.

`nix flake update && sudo nixos-rebuild switch --flake .`

#### Without flakes

To build:

`sudo nixos-rebuild switch .`

To update/upgrade:

`sudo nixos-rebuild switch . --upgrade`
