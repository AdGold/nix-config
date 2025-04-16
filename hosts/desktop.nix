{ pkgs, ... }:

{
  home.username = "ag2198";
  home.homeDirectory = "/home/ag2198";

  imports = [
    ./common.nix
    ./applications.nix
  ];

  home.packages = with pkgs; [
  ];
}
