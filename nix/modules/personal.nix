# Personal machine configuration (Services + GUI)
{ config, lib, pkgs, ... }:

{
  imports = [
    ./dev.nix
    ./gaming.nix
  ];

  config = {
    # Auto-login is fine with FDE
    services.getty = {
      autologinUser = "flover";
      autologinOnce = true;
    };


    # User related setup
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
    services.xserver.enable = false;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
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
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

    # Screen sharing
    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = "wlr";
        };
      };
      wlr.enable = true;
      wlr.settings.screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
      };
    };

    # Input
    services.libinput.enable = true;

    # firmware updates
    services.fwupd.enable = true;

    # Firewall
    networking.firewall.enable = true;

    # 1Password
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "jon" ];
    };

    # Allow directly executing .AppImage
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
      tex-gyre.heros
      public-sans
    ];

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
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    security.pam.services = {
      greetd.enableGnomeKeyring = true;

      # If using a display manager such as GDM
      #gdm.enableGnomeKeyring = true;

      # If using sddm 
      # sddm.enableGnomeKeyring = true;
    };

    environment.systemPackages = with pkgs; [
      aria2
      cifs-utils
      fontforge-fonttools
      ffmpeg-full
      poppler-utils
      ghostty
      spotify
      pv
      stow
    ];
  };
}
