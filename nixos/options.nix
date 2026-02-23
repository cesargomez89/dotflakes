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
  };
}
