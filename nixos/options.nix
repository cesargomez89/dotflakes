{ lib, ... }:

{
  options = {
    enableNvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable NVIDIA GPU support";
    };
    enableNvidiaOffload = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable NVIDIA offload mode for power saving";
    };
    desktopEnv = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Desktop environment: gnome, niri, or empty for none";
    };
    enableNiri = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Niri Wayland compositor";
    };
  };
}
