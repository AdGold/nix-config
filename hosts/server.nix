{ pkgs, ... }:

{
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  imports = [
    ./common.nix
    ./trusted.nix
  ];

  home.packages = with pkgs; [
    openssh
  ];
}
