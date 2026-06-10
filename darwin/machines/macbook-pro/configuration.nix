{ lib, ... }:

{
  imports = [
    ../../base.nix
    ../../desktop.nix
    ./hardware-configuration.nix
  ];
}
