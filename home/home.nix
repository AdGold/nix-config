{ config, pkgs, ... }:

{
  imports = [
    ./dotfiles.nix
  ];

  news.display = "silent";

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
