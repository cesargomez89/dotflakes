{
  pkgs,
  lib,
  ...
}:

lib.mkIf pkgs.stdenv.hostPlatform.isDarwin { }
