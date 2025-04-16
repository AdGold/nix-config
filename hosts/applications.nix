{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    google-chrome
    zathura
    vlc
    ipe
    xournalpp
    brave
  ];
}

