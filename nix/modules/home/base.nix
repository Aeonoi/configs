{ config, pkgs, ... }:

{
  imports = [
  ];

  home-manager.users."flover" =
    { config, pkgs, ... }:
    {
      programs.bash.enable = true;
      programs.fish = {
        enable = true;
        shellInitLast = builtins.readFile ../../../config/.config/fish/config.fish;
      };
      programs.git = {
        enable = true;
        includes = [ { path = ../../../config/.config/git/config; } ];
      };
      programs.neovim = {
        enable = true;
        initLua = builtins.readFile ../../../config/.config/nvim/init.lua;
        defaultEditor = true;
        withPython3 = true;
        withRuby = false;
      };

      home.packages = with pkgs; [
        # bat
        # eza
        # fd
        # jq
        # nix-tree
      ];

      # GUI configuration
      home.sessionVariables = {
        BROWSER = "firefox";
        GDK_BACKEND = "wayland,x11";
        XWAYLAND_DPI = "192";
      };

      home.file.".Xresources".text = ''
        Xft.dpi: 192
      '';

      home.stateVersion = "25.05";
    };
}
