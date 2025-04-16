{ config, pkgs, ... }:

{
  imports = [
    ./dotfiles.nix
  ];

  news.display = "silent";

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
