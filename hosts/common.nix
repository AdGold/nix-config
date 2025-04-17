{ pkgs, ... }:

{
  imports = [ ../home/home.nix ];

  home.packages = with pkgs; [
    zsh
    tmux
    ranger
    neovim
    git
    eza
    fzf
    zoxide
    htop
    unzip
    p7zip
    cargo
    cmake
    gcc
    gnumake
    python3
    python3Packages.pip
    python3Packages.setuptools
    pypy3
    texliveBasic
    ffmpeg
    ncdu
    nodejs
    jq
    atool
    powerline-fonts
    glibcLocales
  ];
}
