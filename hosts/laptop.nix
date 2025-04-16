{ pkgs, ... }:

{
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  imports = [
    ./common.nix
    ./trusted.nix
    ./applications.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    calibre
    picocom
    esptool
  ];
}
