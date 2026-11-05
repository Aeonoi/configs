
{ config, pkgs, ... }:

{
  imports = [ 
  ];

  services.lact.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # DO NOT EDIT!! OS installed on 11/01/2026
  system.stateVersion = "26.05"; # Did you read the comment?
}
