# Personal machine configuration (Services + GUI)
{ config, lib, pkgs, ... }:

{
  imports = [
    ./dev.nix
    ./gaming.nix
  ];

  config = {
    users.users."flover" = {
      isNormalUser = true;
      description = "Dylan";
      shell = pkgs.fish;
      extraGroups = [
        "adm"
        "users"
        "networkmanager"
        "wheel"
        "audio"
        "video"
      ];
    };

    # Enable networking
    networking.networkmanager.enable = true;

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        Policy = {
          AutoEnable = true;
        };
      };
    };

    # No X11
    services.xserver.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    services.pipewire.wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-hw-volume" = false;
        "bluez5.roles" = [
          # "hsp_hs"
          # "hsp_ag"
          # "hfp_hf"
          # "hfp_ag"
          "a2dp_sink"
          "bap_sink"
        ];
      };
    };
    services.pipewire.wireplumber.extraConfig."11-bluetooth-policy" = {
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
    };

    # Printing
    # services.avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    #   openFirewall = true;
    # };
    # services.printing = {
    #   enable = true;
    #   drivers = with pkgs; [
    #     cups-filters
    #     cups-browsed
    #   ];
    # };

    # Input
    services.libinput.enable = true;

    # firmware updates
    services.fwupd.enable = true;

    # Firewall
    # networking.firewall.enable = true;

    # Allow directly executing .AppImage
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    # Install and configure (but do not auto-start) sshd
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "flover" ];
        MaxAuthTries = 2;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };
    systemd.services.sshd.wantedBy = lib.mkForce [ ];

    # Security for GUI session
    security.polkit.enable = true;

    programs.firefox = {
      enable = true;
      preferences = {
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "ui.key.menuAccessKeyFocuses" = false;
        "general.autoScroll" = true;
      };
    };

    programs.google-chrome = {
      enable = true;
      commandLineArgs = [
        "--disable-gpu"
        "--enable-features=VaapiVideoDecoder"
        "--enable-blink-features=MiddleClickAutoscroll"
      ];
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
      tex-gyre.heros
      public-sans
    ];

    environment.systemPackages = with pkgs; [
      fontforge-fonttools
      ffmpeg-normalize
      ffmpeg-full
      spotify
      stow
      mpv
      ani-cli
      texlab
    ];
  };
}
