# Minimal system basics for ALL hosts (including headless servers)
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "America/New_York";

  programs.fish.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.tmux = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    dig
    file
    git
    git-lfs
    btop
    openssh
    tree
    fzf
    # pstree
    # ripgrep
    # rsync
    ncdu
    fastfetch
    # socat
    sudo-rs
    traceroute
    unzip
    uutils-coreutils-noprefix
    wget
    zip
  ];

}
