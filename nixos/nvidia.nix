{ config, lib, ... }:

let
  enableNvidiaOffload = config.enableNvidiaOffload or false;
in

lib.mkIf config.enableNvidia {
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  };

  boot.kernelParams = [ "nvidia-drm.modeset=1" ]
    ++ lib.optionals enableNvidiaOffload [ "nvidia.NVreg_DynamicPowerManagement=0x02" ];

  services.xserver.videoDrivers = if enableNvidiaOffload then [ "modesetting" ] else [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
  } // (if !enableNvidiaOffload then {
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  } else {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      sync.enable = false;
    };
  });
}
