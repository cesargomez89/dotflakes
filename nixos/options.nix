{ lib, ... }:

{
  options = {
    desktopEnv = lib.mkOption {
      type = lib.types.enum [
        ""
        "gnome"
      ];
      default = "";
      description = "Desktop environment: gnome, or empty for none";
    };
  };
}
